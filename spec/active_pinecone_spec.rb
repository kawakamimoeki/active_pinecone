# frozen_string_literal: true

RSpec.describe ActivePinecone do
  it "has a version number" do
    expect(ActivePinecone::VERSION).not_to be nil
  end

  describe "#configure" do
    let(:openai_access_token) { "abc123" }
    let(:pinecone_api_key) { "def456" }
    let(:pinecone_environment) { "ghi789" }

    before do
      ActivePinecone.configure do |config|
        config.openai_access_token = openai_access_token
        config.pinecone_api_key = pinecone_api_key
        config.pinecone_environment = pinecone_environment
      end
    end

    it "returns the config" do
      expect(ActivePinecone.configuration.openai_access_token).to eq(openai_access_token)
      expect(ActivePinecone.configuration.pinecone_api_key).to eq(pinecone_api_key)
      expect(ActivePinecone.configuration.pinecone_environment).to eq(pinecone_environment)
    end

    context "without an openai access token" do
      let(:openai_access_token) { nil }

      it "raises an error" do
        expect { ActivePinecone::Openai.new.embedding }.to raise_error(ActivePinecone::ConfigurationError)
      end
    end

    context "without a pinecone api key" do
      let(:pinecone_api_key) { nil }

      it "raises an error" do
        expect { ActivePinecone::Pinecone.new.index }.to raise_error(ActivePinecone::ConfigurationError)
      end
    end

    context "without a pinecone environment" do
      let(:pinecone_environment) { nil }

      it "raises an error" do
        expect { ActivePinecone::Pinecone.new.index }.to raise_error(ActivePinecone::ConfigurationError)
      end
    end
  end
end