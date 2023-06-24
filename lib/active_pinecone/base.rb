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

    def self.assistant(instruction = 'Context:')
      ActivePinecone::Assistant.new(self, instruction: instruction)
    end

    def self.index_name
      to_s.downcase.pluralize
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
      embeded = openai.embeddings(parameters: { model: ActivePinecone.configuration.embedding_model, input: input })
      embeded['data'][0]['embedding']
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

    def self.init
      pinecone.create_index({ name: index_name, dimension: ActivePinecone.configuration.dimension, metrics: ActivePinecone.configuration.metrics })
    end

    def self.create(**attributes)
      id = attributes[:id] || SecureRandom.uuid
      index.upsert(vectors: [{ id: id, metadata: attributes, values: embed(attributes.slice(vectorized_attributes).to_json) }])
      new(attributes.merge(id: id))
    end

    def self.delete(id)
      index.delete(ids: [id])
    end

    def self.find(id)
      fetched = index.fetch(ids: [id])
      new(fetched['vectors'][id]['metadata'].merge(id: id).symbolize_keys)
    end

    def self.search(text, filter: {})
      searched = index.query(vector: embed(text), filter: filter)
      searched['matches'].map do |match|
        new(match['metadata'].merge(id: match['id']).symbolize_keys)
      end
    end

    def update(**attributes)
      self.class.index.upsert(vectors: [{ id: id, metadata: attributes, values: self.class.embed(attributes.slice(self.class.vectorized_attributes).to_json) }])
      @attributes = attributes
    end
  end
end