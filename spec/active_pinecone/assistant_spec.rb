class Post < ActivePinecone::Base
  vectorizes :title, :body
end

RSpec.describe ActivePinecone::Assistant do
  let(:pinecone) { double(::Pinecone::Client) }
  let(:openai) { double(::OpenAI::Client) }
  let(:assistant) { ActivePinecone::Assistant.new(Post) }
  let(:vector) { double(::Pinecone::Vector) }

  before do
    allow(ActivePinecone::Assistant).to receive(:openai).and_return(openai)
    allow(pinecone).to receive(:index).and_return(vector)
    allow(Post).to receive(:embed).and_return([0.1, 0.2, 0.3])
    allow(Post).to receive(:pinecone).and_return(pinecone)
    allow(Post).to receive(:openai).and_return(openai)
    allow(openai).to receive(:chat).and_return({ 'choices' => [{ 'message' => { 'role' => 'assistant', 'content' => 'test' }}] })

  end

  describe '#reply' do
    it 'replies' do
      allow(vector).to receive(:query).and_return({
        'results' => [], 'matches' => [{ 'id' => '1', 'score' => 0, 'metadata' => { 'title' => 'test', 'body' => 'test' }, 'values' => [0.1, 0.2, 0.3] }] })
      expect(assistant.reply('test').content).to eq('test')
    end
  end

  describe '#messages' do
    before do
      allow(vector).to receive(:query).and_return({
        'results' => [], 'matches' => [{ 'id' => '1', 'score' => 0, 'metadata' => { 'title' => 'test', 'body' => 'test' }, 'values' => [0.1, 0.2, 0.3] }] })
      assistant.reply('test')
    end

    it 'returns messages' do
      expect(assistant.messages[-1].role).to eq('assistant')
    end
  end
end
