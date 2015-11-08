# Starts SimpleCov for code coverage.

if ENV["COVERAGE"]
  require "simplecov"

  # Using a command name along with the test_env_number prevents results from
  # getting clobbered by other test suites
  SimpleCov.command_name ENV["TEST_ENV_COMMAND_NAME"] || File.expand_path("../../../.", __FILE__).basename

  SimpleCov.start("rails") do
    # Consider the entire gem project as the root
    # (typically this will be the folder named "react_on_rails")
    gem_root_path = File.expand_path("../../../../../.", __FILE__)
    root gem_root_path

    # Don't report anything that has "spec" in the path
    # NOTE: this excludes the dummy apps!
    add_filter do |src|
      src.filename =~ %r{\/spec\/}
    end
  end
end
