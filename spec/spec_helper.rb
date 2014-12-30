require 'devise'
require_relative 'authent_macros'

RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.extend AuthentMacros, :type => :controller
  
  config.order = :random

  config.after(:each) do
    Mongoid::Sessions.default.collections.select {|c| c.name !~ /system/}.each {|c| c.find.remove_all}
  end
  

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  #Kernel.srand config.seed

  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # Enable only the newer, non-monkey-patching expect syntax.
    # For more details, see:
    #   - http://myronmars.to/n/dev-blog/2012/06/rspecs-new-expectation-syntax
    expectations.syntax = [:should, :expect]
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :mocha

end
