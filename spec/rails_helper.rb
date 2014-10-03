# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
ENV["AWS_ACCESS_KEY"]="AKIAIP7GOBJUZ6FI6JOQ"
ENV["AWS_SECRET"]="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"
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'stub_chain_mocha'
require 'coveralls'
Coveralls.wear!
Resque.inline = true

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

#upgrade from rspec-rails 2 to 3 : https://github.com/rspec/rspec-rails/issues/932
RSpec.configuration.infer_spec_type_from_file_location!