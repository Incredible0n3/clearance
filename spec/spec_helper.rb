ENV["RAILS_ENV"] ||= "test"

require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
require "mongoid"
require "dummy/application"

require 'database_cleaner'
require "clearance/rspec"
require "factory_girl_rails"
require "rspec/rails"
require "shoulda-matchers"
require "timecop"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

Dummy::Application.initialize!

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.infer_spec_type_from_file_location!
  config.order = :random
  config.use_transactional_fixtures = false

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
  end

  # Cleanup the DB in between test runs
  config.before(:suite) do
    DatabaseCleaner[:mongoid].strategy = :truncation
    DatabaseCleaner[:mongoid].clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

def restore_default_config
  Clearance.configuration = nil
  Clearance.configure {}
end
