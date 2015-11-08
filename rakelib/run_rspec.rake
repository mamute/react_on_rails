require "coveralls/rake/task"
require "pathname"
require_relative "task_helpers"
include ReactOnRails::TaskHelpers

namespace :run_rspec do
  desc "Run RSpec for top level only"
  task :gem do
    run_tests_in("", rspec_args: "spec/react_on_rails")
  end

  desc "Run RSpec for spec/dummy only"
  task :dummy do
    run_tests_in("spec/dummy", env_variables: "DRIVER=selenium_firefox")
  end

  desc "Run RSpec for spec/dummy_react_013 only"
  task :dummy_react_013 do
    run_tests_in("spec/dummy-react-013", env_variables: "DRIVER=selenium_firefox")
  end

  desc "Run RSpec for example apps only"
  task :examples do
    Dir.foreach(examples_dir) do |example_app_dir|
      rspec_target_dir = File.join(examples_dir, examples_dir)
      run_tests_in("", rspec_args: rspec_target_dir)
    end
  end

  desc "Run RSpec on spec/empty_spec in order to have SimpleCov generate a coverage report from cache"
  task :empty do
    sh %(COVERAGE=true rspec spec/empty_spec.rb)
  end

  Coveralls::RakeTask.new

  task run_rspec: [:gem, :dummy, :dummy_react_013, :examples, :empty, "coveralls:push"] do
    puts "Completed all RSpec tests"
  end
end

desc "Runs all tests. Run `rake -D run_rspec` to see all available test options"
task run_rspec: ["run_rspec:run_rspec"]

private

# Runs rspec in the given directory (if string is passed, assumed to be relative
# to root of the gem.
# TEST_ENV_COMMAND_NAME is used to make SimpleCov.command_name unique in order to
# prevent a name collision. Defaults to the given directory's name.
def run_tests_in(dir, options = {})
  dir = Pathname.new(File.join(gem_root, dir)) if dir.is_a?(String)
  command_name = options.fetch(:command_name, dir.basename)
  rspec_args = options.fetch(:rspec_args, "")
  env_variables = %(COVERAGE=true TEST_ENV_COMMAND_NAME="#{command_name}")
  env_variables << options.fetch(:env_variables, "")
  sh %(cd #{dir} && #{env_variables} rspec #{rspec_args})
end
