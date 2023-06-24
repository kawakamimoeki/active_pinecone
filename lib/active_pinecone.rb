# frozen_string_literal: true

require 'openai'
require 'pinecone'
require 'active_support/all'

begin
  require 'active_model'
  require 'active_model/naming'
rescue LoadError
end

module ActivePinecone
  class Error < StandardError; end
  class ConfigurationError < Error; end

  class Configuration
    attr_accessor :embedding_model, :dimension, :metrics, :openai_request_timeout, :chat_model
    attr_writer :openai_access_token, :pinecone_api_key, :pinecone_environment

    DEFAULT_DIMENTION = 1536
    DEFAULT_METRICS = 'cosine'
    DEFAULT_EMBEDDING_MODEL = 'text-embedding-ada-002'
    DEFAULT_CHAT_MODEL = 'gpt-3.5-turbo'
    DEFAULT_REQUEST_TIMEOUT = 120

    def initialize
      @openai_access_token = nil
      @openai_request_timeout = DEFAULT_REQUEST_TIMEOUT
      @pinecone_api_key = nil
      @pinecone_environment = nil
      @embedding_model = DEFAULT_EMBEDDING_MODEL
      @chat_model = DEFAULT_CHAT_MODEL
      @dimension = DEFAULT_DIMENTION
      @metrics = DEFAULT_METRICS
    end

    def openai_access_token
      return @openai_access_token if @openai_access_token

      raise ConfigurationError, 'OpenAI access token missing! See https://github.com/moekidev/actve_pinecone#usage'
    end

    def pinecone_api_key
      return @pinecone_api_key if @pinecone_api_key

      raise ConfigurationError, 'Pinecone API key missing! See https://github.com/moekidev/active_pinecone#usage'
    end

    def pinecone_environment
      return @pinecone_environment if @pinecone_environment

      raise ConfigurationError, 'Pinecone environment missing! See https://github.com/moekidev/active_pinecone#usage'
    end
  end

  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end

require_relative 'active_pinecone/version'
require_relative 'active_pinecone/base'
require_relative 'active_pinecone/openai'
require_relative 'active_pinecone/pinecone'
require_relative 'active_pinecone/assistant'
require_relative 'active_pinecone/message'