module ActivePinecone
  class Base
    attr_reader :attributes

    def initialize(attributes = {})
      attributes.symbolize_keys!
      @attributes = attributes
      attributes.dup.each do |key, value|
        define_singleton_method("#{key}=") { |value| @attributes[key] = value }
        define_singleton_method(key) { @attributes[key] }
        send "#{key}=", value
      end
    end

    def self.assistant
      ActivePinecone::Assistant.new(self)
    end

    def self.index_name
      to_s
    end

    def self.pinecone
      @pinecone ||= ActivePinecone::Pinecone.new
    end

    def self.openai
      @openai ||= ActivePinecone::Openai.new
    end

    def self.describe
      pinecone.describe_index(index_name)
    end

    def self.embed(input)
      openai.embeddings(parameters: { model: ActivePinecone.configuration.embedding_model, input: input })
    end

    def self.vectorized_attributes
      @@vectorized_attributes
    end

    def self.index
      pinecone.index(index_name)
    end

    def self.vectorizes(*attr_names)
      @@vectorized_attributes ||= []
      @@vectorized_attributes += attr_names
    end

    def self.create(**attributes)
      id = attributes[:id] || SecureRandom.uuid
      index.upsert(vectors: [{ id: id, metadata: attributes, values: embed(attributes.slice(vectorized_attributes).to_json) }])
      new(attributes.merge(id: id))
    end

    def self.delete(id)
      index.delete(ids: [id])
    rescue ::Pinecone::IndexNotFoundError
      pinecone.create_index({ name: index_name, dimension: ActivePinecone.configuration.dimension, metrics: ActivePinecone.configuration.metrics })
    end

    def self.find(id)
      fetched = index.fetch(ids: [id])
      new(fetched['vectors'][id]['metadata'].merge(id: id).symbolize_keys)
    rescue ::Pinecone::IndexNotFoundError
      pinecone.create_index({ name: index_name, dimension: ActivePinecone.configuration.dimension, metrics: ActivePinecone.configuration.metrics })
    end

    def self.search(text, filter: {})
      searched = index.query(vector: embed(text), filter: filter)
      searched['matches'].map do |match|
        new(match['metadata'].merge(id: match['id']).symbolize_keys)
      end
    rescue ::Pinecone::IndexNotFoundError
      pinecone.create_index({ name: index_name, dimension: ActivePinecone.configuration.dimension, metrics: ActivePinecone.configuration.metrics })
    end

    def update(**attributes)
      self.class.index.upsert(vectors: [{ id: id, metadata: attributes, values: self.class.embed(attributes.slice(self.class.vectorized_attributes).to_json) }])
      @attributes = attributes
    rescue ::Pinecone::IndexNotFoundError
      pinecone.create_index({ name: index_name, dimension: ActivePinecone.configuration.dimension, metrics: ActivePinecone.configuration.metrics })
    end
  end
end