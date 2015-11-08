require_relative "task_helpers"
include ReactOnRails::TaskHelpers

namespace :travis do
  desc "Run all tests and linting"
  task run: [:run_rspec, :lint]

  task :install do
    rm_rf("~/.nvm && git clone https://github.com/creationix/nvm.git ~/.nvm" \
          "&& (cd ~/.nvm && git checkout `git describe --abbrev=0 --tags`)" \
          "&& source ~/.nvm/nvm.sh && nvm install 4.2.0")
    sh_in_dir(gem_root, "npm install -g npm
                         bundle install
                         cd spec/dummy/client && npm install
                         $(npm bin)/webpack --config webpack.server.js
                         $(npm bin)/webpack --config webpack.client.js
                         cd spec/dummy-react-013/client && npm install
                         $(npm bin)/webpack --config webpack.server.js
                         $(npm bin)/webpack --config webpack.client.js
                         docker-compose up lint")
  end
end
