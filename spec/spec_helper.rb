# spec/spec_helper.rb
RSpec.configure do |config|
  # rspec-expectations config
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.example_status_persistence_file_path = "spec/examples.txt"
  config.disable_monkey_patching!
  config.warnings = true

  # Use the new `expect` syntax by default
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
