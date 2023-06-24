# frozen_string_literal: true

require 'active_pinecone'

ActivePinecone.configure do |config|
  config.openai_access_token = ENV.fetch('OPENAI_ACCESS_TOKEN')
  config.pinecone_api_key = ENV.fetch('PINECONE_API_KEY')
  config.pinecone_environment = ENV.fetch('PINECONE_ENVIRONMENT')
end

class Post < ActivePinecone::Base
  vectorizes :title, :body
end