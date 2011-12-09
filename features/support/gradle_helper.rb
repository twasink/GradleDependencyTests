module Twasink
  module GradleHelper

    # To change this template use File | Settings | File Templates.

    def clean_repository
      @projects = Hash.new
    end

    def start_scenario(name)
      @working_dir = File.join("projects", name.downcase.gsub(/[ ,]/, '_'))
      puts "working dir = #{@working_dir}"
    end

    def create_project(args)
      project = Project.new(working_dir: @working_dir, name: args[:project], version: args[:version])
      puts "project key = #{project.key}"

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
      puts "adding to project #{key} - #{args}"
      dependencies << [name: args[:project], version: args[:version]]
    end

    def build
      puts "building this project - #{key}"
    end

  end
end
