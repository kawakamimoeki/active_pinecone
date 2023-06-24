# frozen_string_literal: true

require 'active_pinecone'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

RSpec.configure do |c|
  c.before(:all) do
    ActivePinecone.configure do |config|
      config.openai_access_token = ENV.fetch('OPENAI_ACCESS_TOKEN', 'test')
      config.pinecone_api_key = ENV.fetch('PINECONE_API_KEY', 'test')
      config.pinecone_environment = ENV.fetch('PINECONE_ENVIRONMENT', 'test')
    end
  end
end
