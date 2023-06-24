module ActivePinecone
  class Message
    attr_reader :role, :content, :references

    def initialize(role:, content:, references: [])
      @role = role
      @content = content
      @references = references
    end
  end
end