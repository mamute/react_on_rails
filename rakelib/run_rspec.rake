require "coveralls/rake/task"
require_relative "task_helpers"
include ReactOnRails::TaskHelpers

namespace :run_rspec do
  desc "Run RSpec for top level only"
  task :gem do
    run_tests_in("spec/react_on_rails")
  end

  desc "Run RSpec for spec/dummy only"
  task :dummy do
    run_tests_in("spec/dummy", "DRIVER=selenium_firefox")
  end

  desc "Run RSpec for spec/dummy_react_013 only"
  task :dummy_react_013 do
    run_tests_in("spec/dummy_react_013", "DRIVER=selenium_firefox")
  end

  desc "Run RSpec for example apps only"
  task :examples do
    Dir.foreach(examples_dir) { |example_app_dir| run_tests_in(example_app_dir) }
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
def run_tests_in(dir, options = "")
  dir = Pathname.new(File.join(gem_root, dir)) if dir.is_a?(String)
  command_name = dir.basename
  sh %(cd #{dir} && COVERAGE=true TEST_ENV_COMMAND_NAME="#{command_name}" #{options} bundle exec rspec)
end
