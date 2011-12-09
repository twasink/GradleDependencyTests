require 'fileutils'

module Twasink
  module GradleHelper

    # To change this template use File | Settings | File Templates.

    def clean_repository
      @projects = Hash.new

      @repo_dir = File.join(@working_dir, "repo")
      if (File.exists? @repo_dir)
        FileUtils.rmtree(@repo_dir)
      end

      maven_repo = File.join(ENV['HOME'], '.m2', 'repository', 'net', 'twasink')
      if (File.exists? maven_repo)
        FileUtils.rmtree(maven_repo)
      end
    end

    def start_scenario(name)
      @scenario_name_normalized = name.downcase.gsub(/[ ,]/, '_')
      @working_dir = File.join("projects", @scenario_name_normalized)
    end

    def create_project(args)
      unless @projects.has_key?(Project.key(args))
        project = Project.new(working_dir: @working_dir, name: args[:name],
                              group: @scenario_name_normalized, version: args[:version])

        @projects[project.key] = project
      end
      
      return @projects[Project.key(args)]
    end

    def build_all_projects_except(args)
      unwanted_project_key = Project.key(name: args[:project], version: args[:version])
      @projects.each() { | key, project |
        project.gradle_build() unless key.start_with?(unwanted_project_key)
      }
    end
    def maven_build_all_projects_except(args)
      unwanted_project_key = Project.key(name: args[:project], version: args[:version])
      @projects.each() { | key, project |
        project.maven_build() unless key.start_with?(unwanted_project_key)
      }
    end

    def maven_dependencies_for(args)
      return @projects[Project.key(name: args[:project], version: args[:version])].maven_dependencies
    end
    def dependencies_for(args)
      return @projects[Project.key(name: args[:project], version: args[:version])].gradle_dependencies
    end
  end

  class Project
    attr_reader :working_dir, :group, :name, :version, :dependencies

    def initialize args
      args.each do |k, v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
      @dependencies = Array.new
    end

    def key
      return Project.key(name: @name, version: @version)
    end

    def Project.key(args)
      return "#{args[:name]}:#{args[:version]}"
    end

    def add_dependency(args)
      dependencies << { name: args[:name], version: args[:version] }
    end

    def _init_project
      unless @already_initialized
        @project_dir = File.join(@working_dir, "#{@name.downcase}_#{@version}")
        if (File.exists? @project_dir)
          FileUtils.rmtree(@project_dir)
        end
        FileUtils.mkpath(File.join(@project_dir, 'build'))
        FileUtils.mkpath(File.join(@project_dir, 'target'))

        _create_gradle_files
        _create_maven_files
        _create_java_file
        @already_initialized = true
      end
    end

    def gradle_build
      unless @gradle_built
        _init_project()
        result = _perform_gradle_task('uploadArchives')
        File.write(File.join(@project_dir, 'build', 'gradle.log'), result)
        @gradle_built = true
      end
    end

    def maven_build
      unless @maven_built
        _init_project()
        result = _perform_maven_task('install')
        File.write(File.join(@project_dir, 'target', 'maven.log'), result)
        @maven_built = true
      end
    end

    def gradle_dependencies
      _init_project()
      result = _perform_gradle_task('compiledeps')
      File.write(File.join(@project_dir, 'build', 'dependencies.log'), result)

      return result
    end
    
    def maven_dependencies
      _init_project()
      result = _perform_maven_task('dependency:tree')
      File.write(File.join(@project_dir, 'target', 'dependencies.log'), result)

      return result
    end

    def _write_template(path, filename)
      template = ERB.new(IO.read(File.join(File.dirname(__FILE__), 'fixtures', "#{filename}.erb")))
      IO.write(File.join(path, filename), template.result(binding))
    end

    def _create_gradle_files
      _write_template @project_dir, 'build.gradle'
      _write_template @project_dir, 'settings.gradle'
    end

    def _create_maven_files
      _write_template @project_dir, 'pom.xml'
    end

    def _create_java_file

      package_dir = File.join(@project_dir, 'src', 'main', 'java', 'net', 'twasink', @name.downcase)
      FileUtils.mkpath(package_dir)

      _write_template package_dir, 'Hello.java'

    end

    def _perform_gradle_task(task)
      commands = ["GRADLE_HOME=#{File.absolute_path('gradle_build')}",
                  "pushd #{@project_dir} > /dev/null",
                  "$GRADLE_HOME/bin/gradle -q #{task} 2>&1",
                  "popd > /dev/null"
      ]
      `#{commands.join('; ')}`
    end

    def _perform_maven_task(task)
      commands = ["pushd #{@project_dir} > /dev/null",
                  "mvn #{task} 2>&1",
                  "popd > /dev/null"
      ]
      `#{commands.join('; ')}`
    end
  end
end
