module ActivePinecone
  class Assistant
    attr_reader :model, :instruction

    def initialize(model, instruction: 'Context:')
      @model = model
      @instruction = instruction
      @messages_with_system = [{ role: 'system', content: '' }]
    end

    def self.openai
      @openai ||= ActivePinecone::Openai.new
    end

    def messages
      @messages_with_system.drop(1)
    end

    def reply(message)
      @messages_with_system << { role: 'user', content: message }

      records = model.search(messages.pluck(:content))

      @messages_with_system[0][:content] = [instruction, records.map(&:attributes).to_json].join("\n")

      result = self.class.openai.chat(
        parameters: { model: ActivePinecone.configuration.chat_model, messages: messages, temperature: 0.7 }
      )
      rep = ActivePinecone::Message.new(role: 'assistant', content: result['choices'][0]['message']['content'], references: messages)
      @messages_with_system << rep
      rep
    end
  end
end
