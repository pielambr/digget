if ENV['TRAVIS']
  require 'simplecov'
  SimpleCov.start do
    add_filter 'spec/'
  end

  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

ENV['RAILS_ENV'] ||= 'test'

require 'dummy/config/environment'

ActiveRecord::Migration.maintain_test_schema!
ActiveRecord::Schema.verbose = false
load 'dummy/db/schema.rb'

require File.expand_path('../dummy/config/application', __FILE__)

require 'rspec/rails'
require 'digget/validator'
require 'i18n'
require 'byebug'

require 'database_cleaner'

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

end
