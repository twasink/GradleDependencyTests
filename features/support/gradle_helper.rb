module Twasink
  module GradleHelper

    # To change this template use File | Settings | File Templates.

    def clean_repository
      @projects = Hash.new
    end

    def start_scenario(name)
      @working_dir = File.join("projects", name.downcase.gsub(/[ ,]/, '_'))
    end

    def create_project(args)
      project = Project.new(working_dir: @working_dir, name: args[:project], version: args[:version])

      @projects[project.key] = project
    end

    def build_all_projects_except(args)
      unwanted_project_key = Project.key(name: args[:project], version: args[:version])
      @projects.each() { | key, project | project.build() unless unwanted_project_key.eql?(key) }
    end

    def dependencies_for(args)
      return @projects[Project.key(name: args[:project], version: args[:version])].dependencies
    end
  end

  class Project
    attr_reader :working_dir, :name, :version, :dependencies

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
      dependencies << [name: args[:project], version: args[:version]]
    end

    def build
      @project_dir = File.join(@working_dir, "#{@name}_#{@version}")
      if (File.exists? @project_dir)
        FileUtils.rmtree(@project_dir)
      end
      FileUtils.mkpath(@project_dir)

      _create_gradle_files
      _create_java_file
      _gradle_build
    end

    def _write_template(path, filename)
      template = ERB.new(IO.read(File.join(File.dirname(__FILE__), 'fixtures', "#{filename}.erb")))
      IO.write(File.join(path, filename), template.result(binding))
    end

    def _create_gradle_files
      _write_template @project_dir, 'build.gradle'
      _write_template @project_dir, 'settings.gradle'
    end

    def _create_java_file

      package_dir = File.join(@project_dir, 'src', 'main', 'java', 'net', 'twasink', @name.downcase)
      FileUtils.mkpath(package_dir)

      _write_template package_dir, 'Hello.java'

    end

    def _gradle_build
      
    end
  end
end
