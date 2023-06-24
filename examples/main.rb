# frozen_string_literal: true

require_relative 'post'

Post.init

post = Post.create(title: 'This is An Example', body: 'This is an example', author: 'Kevin')

p post.title #=> 'This is An Example'

p post.author #=> 'Kevin'

post.update(body: 'This will be changed')

posts = Post.search('example')

posts.each do |pt|
  p pt.title #=> 'This is An Example'
end

assistant = Post.assistant

p assistant.reply('hoge')

p assistant.messages
