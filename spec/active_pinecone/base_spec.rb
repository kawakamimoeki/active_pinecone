class Post < ActivePinecone::Base
  vectorizes :title, :body
end

RSpec.describe Post do
  let(:pinecone) { double(::Pinecone::Client) }
  let(:openai) { double(::OpenAI::Client) }
  let(:vector) { double(::Pinecone::Vector) }

  before do
    allow(::Pinecone::Client).to receive(:new).and_return(pinecone)
    allow(pinecone).to receive(:index).and_return(vector)
    allow(Post).to receive(:embed).and_return([0.1, 0.2, 0.3])
    allow(Post).to receive(:pinecone).and_return(pinecone)
    allow(Post).to receive(:openai).and_return(openai)
  end

  describe '.create' do
    it 'creates the index' do
      allow(vector).to receive(:upsert).and_return(true)
      Post.create(title: 'test', body: 'test')
    end
  end

  describe '.delete' do
    it 'deletes the index' do
      allow(vector).to receive(:delete).and_return(true)
      Post.delete(1)
    end
  end

  describe '.find' do
    it 'finds the index' do
      allow(vector).to receive(:fetch).and_return({
        'vectors' => { '1' => { 'id' => '1', 'metadata' => { 'title' => 'test', 'body' => 'test' }, 'values' => [0.1, 0.2, 0.3] }}
      })
      expect(Post.find('1').title).to eq('test')
    end
  end

  describe '.search' do
    it 'searches the index' do
      allow(vector).to receive(:query).and_return({
        'results' => [], 'matches' => [{ 'id' => '1', 'score' => 0, 'metadata' => { 'title' => 'test', 'body' => 'test' }, 'values' => [0.1, 0.2, 0.3] }] })
      expect(Post.search('test').first.title).to eq('test')
    end
  end

  describe '#update' do
    it 'updates the index' do
      allow(vector).to receive(:upsert).and_return(true)
      post = Post.create(title: 'test', body: 'test')
      post.update(title: 'test2', body: 'test2')
      expect(post.title).to eq('test2')
    end
  end
end