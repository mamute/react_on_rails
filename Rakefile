# Rake will automatically load any *.rake files inside of the "rakelib" folder
desc "Run all tests and linting"
task default: ["run_rspec", "docker:lint"]

desc "CI: Run all tests and linting"
task ci: %w(run_rspec lint)
