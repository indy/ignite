require 'erb'
require 'pp'

module Ignite

  class BaseIgnitor

    include Parser

    def self.inherited(child)
      BaseIgnitor.registered_plugins[child.to_s.camel_to_underscore] = child
    end

    @registered_plugins = {};                     # registered plugins
    @@plugin_directories = []  # the default plugin location

    class << self;
      attr_reader :registered_plugins
    end

    def self.load_user_plugins
      user_plugin_directory = File.join(ENV["HOME"], ".ignite")

      if File.exist? user_plugin_directory
        load_plugins user_plugin_directory
      end
    end

    def self.load_default_plugins
      load_plugins(File.join(File.dirname(__FILE__), "..", "..", "plugins"))
    end

    def self.load_plugins(plugin_directory)
      unless @@plugin_directories.include?(plugin_directory)
        @@plugin_directories << plugin_directory
      end

      Dir.list_directories(plugin_directory).map do |d|
        unless (d =~ /^[._]/)       # ignore svn, darcs directories
          load(File.join(plugin_directory, d, "#{d}.rb"))
        end
      end
    end

    def self.display_help
      # array of name/description pairs
      nd = registered_plugins.collect { |k,v|
        obj = v.new
        [k, obj.respond_to?("description") ? "#{obj.description}" : ""]
      }

      longest_length = nd.max {|a,b| a[0].length <=> b[0].length }[0].length

      puts
      puts "ignite sets up file and directory structures for a variety of projects"
      puts
      puts "Usage: ignite <task> <name of project>"
      puts
      puts "Available ignite tasks:"
      nd.sort { |a,b| a[0] <=> b[0] }.each { |pair|
        puts "  #{pair[0]}#{' '.rjust(longest_length + 1 - pair[0].length)} : #{pair[1]}"
      }
    end

    # called at start to find the class to instantiate
    def self.select_plugin(name)
      registered_plugins[name]
    end

    def parent_directory
      # the directory from which ignite was invoked
      # override this if you always want to start from a specific location (see tad)
      "."
    end

    def resolve_plugin_directory(name)
      @@plugin_directories.find { |d|
        full = File.join(d, name)
        File.exist?(full) && File.directory?(full)
      }
    end

    def my_name
      BaseIgnitor.registered_plugins.detect { |k, v| v == self.class }[0]
    end

    def my_class
      BaseIgnitor.registered_plugins.detect { |k, v| v == self.class }[1]
    end

    def my_directory
      plugin_directory = resolve_plugin_directory(my_name)
      File.join(plugin_directory, my_name)
    end


    def parse_template(full_path, current_directory, name)
      erb = ERB.new(File.read(full_path))
      File.open(File.join(current_directory, name), "w") { |f|
        f << erb.result(binding)
      }
    end

    def create_file(current_directory, name, template)

      full_path = File.join(my_directory, "templates", template)

      parse_template(full_path, current_directory, name)
    end

    def walk(current_directory, struc)
      struc.each do |k, v|
        if v.class == Hash
          new_directory = File.join(current_directory, k)
          Dir.ensure_exists new_directory
          walk(new_directory, v) if v.class == Hash
        elsif v.class == String
          create_file(current_directory, k, v)
        end
      end
    end


    def load_structure
      full_path = File.join(my_directory, my_name) + ".structure"
      File.read(full_path)
    end

    attr_reader :name
    attr_reader :app_name

    # do all the work
    def ignite(name)
      @name = name
      @app_name = name
      current_directory = parent_directory

      struc = parse load_structure

      walk(current_directory, struc)
    end

  end
end
