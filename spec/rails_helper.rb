# spec/rails_helper.rb
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'capybara/rspec'

# Maintain test schema
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  # Only set fixture_path if rspec-rails provided the accessor
  if config.respond_to?(:fixture_path=)
    config.fixture_path = "#{::Rails.root}/spec/fixtures"
  end

  # Use transactional fixtures if supported
  if config.respond_to?(:use_transactional_fixtures=)
    config.use_transactional_fixtures = true
  end

  # These helpers are provided by rspec-rails; guard to avoid NoMethodError
  config.infer_spec_type_from_file_location! if config.respond_to?(:infer_spec_type_from_file_location!)
  config.filter_rails_from_backtrace! if config.respond_to?(:filter_rails_from_backtrace!)
end
