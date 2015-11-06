require "fileutils"
require "coveralls/rake/task"

namespace :run_rspec do
  desc "Run RSpec for top level only"
  task :gem do
    sh %( COVERAGE=true rspec spec/react_on_rails )
  end

  desc "Run RSpec for spec/dummy only"
  task :dummy do
    # TEST_ENV_NUMBER is used to make SimpleCov.command_name unique in order to
    # prevent a name collision
    sh %( cd spec/dummy && DRIVER=selenium_firefox COVERAGE=true TEST_ENV_COMMAND_NAME="dummy-tests" rspec )
  end

  desc "Run RSpec for spec/dummy only"
  task :dummy_react_013 do
    # TEST_ENV_NUMBER is used to make SimpleCov.command_name unique in order to
    # prevent a name collision
    sh %( cd spec/dummy-react-013 &&
          DRIVER=selenium_firefox COVERAGE=true TEST_ENV_COMMAND_NAME="dummy-react-013-tests" rspec )
  end

  desc "Run RSpec on spec/empty_spec in order to have SimpleCov generate a coverage report from cache"
  task :empty do
    sh %( COVERAGE=true rspec spec/empty_spec.rb )
  end

  Coveralls::RakeTask.new

  task run_rspec: [:gem, :dummy, :dummy_react_013, :empty, "coveralls:push"] do
    puts "Completed all RSpec tests"
  end
end
desc "Runs all tests. Run `rake -D run_rspec` to see all available test options"
task run_rspec: ["run_rspec:run_rspec"]

task default: ["run_rspec", "docker:lint"]

namespace :lint do
  desc "Run Rubocop as shell"
  task :rubocop do
    sh "rubocop ."
  end

  desc "Run ruby-lint as shell"
  task :ruby do
    sh "ruby-lint app spec lib"
  end

  desc "Run scss-lint as shell"
  task :scss do
    sh "scss-lint spec/dummy/app/assets/stylesheets/"
  end

  desc "Run eslint as shell"
  task :eslint do
    sh "eslint . --ext .jsx and .js"
  end

  desc "Run jscs from shell"
  task :jscs do
    sh "jscs -e -v ."
  end

  desc "Run all eslint, jscs, rubocop linters. Skip ruby-lint and scss"
  task lint: [:eslint, :jscs, :rubocop] do
    puts "Completed all linting"
  end
end

desc "Runs all linters. Run `rake -D lint` to see all available lint options"
task lint: ["lint:lint"]

namespace :docker do
  desc "Run Rubocop linter from docker"
  task :rubocop do
    sh "docker-compose run lint rake lint:rubocop"
  end

  desc "Run ruby-lint linter from docker"
  task :ruby do
    sh "docker-compose run lint rake lint:ruby"
  end

  desc "Run scss-lint linter from docker"
  task :scss do
    sh "docker-compose run lint rake lint:scss"
  end

  desc "Run eslint linter from docker"
  task :eslint do
    sh "docker-compose run lint rake lint:eslint"
  end

  desc "Run jscs linter from docker"
  task :jscs do
    sh "docker-compose run lint rake lint:jscs"
  end
  desc "Run all linting from docker"
  task :lint do
    sh "docker-compose run lint rake lint"
  end
end

desc "Runs all linters from docker. Run `rake -D docker` to see all available lint options"
task docker: ["docker:lint"]

desc "Run all tests and linting"
task ci: %w(run_rspec lint)

# Runs react_on_rails generators with varying options and puts each result
# in the `examples` folder.
namespace :examples do
  # Define the example types you want to generate here, "name" will be
  # used as the folder name, and options will be given as arguments
  # to the generator.
  EXAMPLE_TYPES = [
    { name: "basic", generator_options: "" },
    { name: "basic-server-rendering", options: "--server-rendering" },
    { name: "redux", options: "--redux --server-rendering" },
    { name: "redux-server-rendering", options: "--redux --server-rendering" }
  ]

  # Where the example folders will be placed
  EXAMPLE_FOLDER = File.expand_path("../examples", __FILE__)

  # REQUIRED_GEMS = %w()

  # Options that must be included with every generator
  # TODO: REQUIRED_GENERATOR_OPTIONS = "--dev-tests"
  # EXAMPLE_TYPES.each do |example_type|
  #   example_type[:options] << " #{REQUIRED_GENERATOR_OPTIONS}" # space is important
  # end

  # Define tasks for generating each example type
  EXAMPLE_TYPES.each do |example_type|
    desc "Generate #{example_type[:name]} example"
    task "gen_#{example_type[:name]}" do
      Rake::Task["examples:clean_#{example_type[:name]}"].invoke
      mkdir_p(example_type_dir(example_type))
      rails_options = "--skip-bundle --skip-spring --skip-git --skip-test-unit"
      sh %(cd #{EXAMPLE_FOLDER} && rails new #{example_type[:name]} #{rails_options})
      # sh %(cd #{example_type_dir(example_type)} && rails generate react_on_rails:install #{example_type[:options]})
      # sh %(cd #{example_type_dir(example_type)} && bundle install)
      # sh %(cd #{example_type_dir(example_type)} && npm install)
    end
  end

  # Define tasks for deleting each example type folder
  EXAMPLE_TYPES.each do |example_type|
    desc "Delete #{example_type[:name]} example"
    task "clean_#{example_type[:name]}" do
      target = example_type_dir(example_type)
      rm_rf(target) if Dir.exist?(target)
    end
  end

  desc "Delete all examples"
  task :clean_all do
    rm_rf(EXAMPLE_FOLDER) if Dir.exist?(EXAMPLE_FOLDER)
  end

  desc "Generate all examples"
  task :gen_all do
    Rake::Task["examples:clean_all"].invoke
    EXAMPLE_TYPES.each { |example_type| Rake::Task["examples:gen_#{example_type[:name]}"].invoke }
  end

  def example_type_dir(example_type)
    File.join(EXAMPLE_FOLDER, example_type[:name])
  end
end

desc "Generates all example apps. Run `rake -D examples` to see all available options"
task examples: ["examples:gen_all"]
