module ActivePinecone
  class Pinecone < Pinecone::Client
    def initialize
      ::Pinecone.configure do |config|
        config.api_key = ActivePinecone.configuration.pinecone_api_key
        config.environment = ActivePinecone.configuration.pinecone_environment
      end

      super
    end
  end
end