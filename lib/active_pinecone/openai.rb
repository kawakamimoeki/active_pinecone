module ActivePinecone
  class Openai < OpenAI::Client
    def initialize
      super(
        access_token: ActivePinecone.configuration.openai_access_token,
        request_timeout: ActivePinecone.configuration.openai_request_timeout
      )
    end
  end
end