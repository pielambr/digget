if ENV['TRAVIS']
  require 'simplecov'
  SimpleCov.start do
    add_filter 'spec/'
  end

  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../dummy/config/environment", __FILE__)
require 'rspec/rails'
require 'digget/validator'
require 'i18n'
require 'byebug'
