require "rails/generators"
require File.expand_path("../generator_helper", __FILE__)
include GeneratorHelper

module ReactOnRails
  module Generators
    class DevTestsGenerator < Rails::Generators::Base
      hide!
      source_root(File.expand_path("../templates/dev_tests", __FILE__))

      def copy_rspec_files
        %w(spec/spec_helper.rb
           spec/rails_helper.rb
           .rspec).each { |file| copy_file(file) }
      end

      def copy_tests
        %w(spec/features/hello_world_spec.rb).each { |file| copy_file(file) }
      end

      def add_test_related_gems_to_gemfile
        gem("rspec-rails", group: :test)
        gem("capybara", group: :test)
        gem("selenium-webdriver", group: :test)
      end
    end
  end
end
