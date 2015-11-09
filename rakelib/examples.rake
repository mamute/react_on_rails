require "rake/clean"

require_relative "task_helpers"
include ReactOnRails::TaskHelpers

# Runs react_on_rails generators with varying options and puts each result
# in the `examples` folder.
namespace :examples do
  # Define the example types you want to generate here, "name" will be
  # used as the folder name, and options will be given as arguments
  # to the generator.
  EXAMPLE_TYPES = [
    { name: "basic", options: "" },
    { name: "basic-server-rendering", options: "--server-rendering" },
    { name: "redux", options: "--redux --server-rendering" },
    { name: "redux-server-rendering", options: "--redux --server-rendering" }
  ]

  # Gems we need to add to the Gemfile before bundle installing
  REQUIRED_GEMS = [
    "gem 'react_on_rails', path: '../../.'",
    "gem 'therubyracer'"
  ]

  # Options we pass when running `rails new` from the command-line
  RAILS_OPTIONS = "--skip-bundle --skip-spring --skip-git --skip-test-unit --skip-active-record"

  # Dynamically define tasks for generating each example type
  EXAMPLE_TYPES.each do |example_type|
    desc "Generates #{example_type[:name]} example. Pass 1 to also run npm install (defaults to false)"
    task "gen_#{example_type[:name]}" do
      Rake::Task["examples:clean_#{example_type[:name]}"].invoke
      example_type_dir = example_dir_for(example_type)

      mkdir_p(example_type_dir)
      sh_in_dir(examples_dir, "rails new #{example_type[:name]} #{RAILS_OPTIONS}")
      append_to_gemfile_in(example_type_dir, REQUIRED_GEMS)
      run_generator_for(example_type)
      npm_install_for(example_type)
      build_client_bundle_for(example_type)
      build_server_bundle_for(example_type) if server_rendering_enabled?(example_type)
    end
  end

  # Dynamically define tasks for cleaning each example type folder
  EXAMPLE_TYPES.each do |example_type|
    desc "Deletes #{example_type[:name]} example"
    task "clean_#{example_type[:name]}" do
      target = example_dir_for(example_type)
      rm_rf(target) if Dir.exist?(target)
    end
  end

  # TODO: Dynamically define tasks for clobbering each example type folder
  EXAMPLE_TYPES.each do |example_type|
    desc "Deletes #{example_type[:name]} example"
    task "clobber_#{example_type[:name]}" do
      target = example_dir_for(example_type)
      rm_rf(target) if Dir.exist?(target)
    end
  end

  desc "Deletes examples folder"
  task :clean_all do
    rm_rf(examples_dir) if Dir.exist?(examples_dir)
  end

  desc "Generates all examples"
  task :gen_all do
    Rake::Task["examples:clean_all"].invoke
    EXAMPLE_TYPES.each { |example_type| Rake::Task["examples:gen_#{example_type[:name]}"].invoke }
  end
end

desc "Generates all example apps. Run `rake -D examples` to see all available options"
task examples: ["examples:gen_all"]

private

# Appends lines of text in an array to the Gemfile inside of the given directory.
# Automatically adds line returns.
def append_to_gemfile_in(parent_dir, lines)
  gemfile = File.join(parent_dir, "Gemfile")
  old_text = File.read(gemfile)
  new_text = lines.reduce(old_text) { |a, e| a << "#{e}\n" }
  File.open(gemfile, "w") { |f| f.puts(new_text) }
end

# Retrieves the directory of a given example_type
def example_dir_for(example_type)
  File.join(examples_dir, example_type[:name])
end

# Shell commands to install the example application AFTER `rails new` has been run
def run_generator_for(example_type)
  shell_commands = "bundle install
                    rails generate react_on_rails:install #{example_type[:options]}
                    rails generate react_on_rails:dev_tests #{example_type[:options]}
                    bundle install"
  sh_in_dir(example_dir_for(example_type), shell_commands)
end

def client_dir_for(example_type)
  File.join(example_dir_for(example_type), "client")
end

def npm_install_for(example_type)
  sh_in_dir(client_dir_for(example_type), "npm install")
end

def build_client_bundle_for(example_type)
  sh_in_dir(client_dir_for(example_type), "webpack --config webpack.client.rails.config.js")
end

def build_server_bundle_for(example_type)
  sh_in_dir(client_dir_for(example_type), "webpack --config webpack.server.rails.config.js")
end

def server_rendering_enabled?(example_type)
  example_type[:options].include?("--server-rendering")
end
