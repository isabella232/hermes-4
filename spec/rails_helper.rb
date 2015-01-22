# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)

require 'rspec/rails'
require 'rspec/autorun'
require 'rspec/collection_matchers'
require 'spec_helper'
require 'shoulda/matchers'
require 'email_spec'
require 'ffaker'
require 'devise'
require 'capybara/poltergeist'
require 'capybara-screenshot/rspec'

if RUBY_VERSION.to_f < 2.0
  require 'debugger'
else
 require 'byebug'
end

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

ActiveRecord::Migration.maintain_test_schema!

Capybara.register_driver :poltergeist_debug do |app|
  Capybara::Poltergeist::Driver.new(app, inspector: true)
end

Capybara.register_driver :with_referer do |app|
  Capybara::RackTest::Driver.new(app, :headers => {'HTTP_REFERER' => 'http://example.com'})
end

Capybara.javascript_driver = :poltergeist_debug
Capybara.default_wait_time = 15
Capybara::Screenshot.autosave_on_failure = true


RSpec.configure do |config|
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)

  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = false

  config.infer_base_class_for_anonymous_controllers = false

  config.order = "random"

  config.mock_with :rspec do |c|
    c.yield_receiver_to_any_instance_implementation_blocks = true
  end

  config.infer_spec_type_from_file_location!

  config.after(:each) { Warden.test_reset! }

end
