# ActivePinecone

ActiveRecord-esque base class that lets you use Pinecone.
Enjoy development with LLM and Rails!

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add active_pinecone

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install active_pinecone

## Usage

### Configuration

Initialize AcitvePinecone configuration.

```ruby
ActivePinecone.configure do |config|
  config.openai_access_token = ENV.fetch("OPENAI_ACCESS_TOKEN")
  config.pinecone_api_key = ENV.fetch("PINECONE_API_KEY")
  config.pinecone_environment = ENV.fetch("PINECONE_ENVIRONMENT")
end
```

### Model

Define a model.

```ruby
class Recipe < ActivePinecone::Base
  vectorize :title, :body
end
```

### Initialize

Create Pinecone index. Index initialization takes a few minutes.

```ruby
Post.init
```


### Create

Pinecone index `Recipe` is created automatically.

```ruby
recipe = Recipe.create(
  title: "Example recipe",
  body: "This is an example.",
  author: "Kevin" # not vectorized
)

p recipe.id
# => b49859ba-1956-4212-8dd4-1b45b3e4e240
```

### Update

```ruby
recipe = Recipe.find(id)
recipe.update(body: "This will be changed.")

p recipe.body
# => "This will be changed."
```

### Search

```ruby
recipes = Recipe.search("Example")

p recipes.first.title
# =>  "Example recipe"
```

### Assistant

Assistant search vector data by **ALL** conversation history and reply.

```ruby
assistant = Recipe.assistant

reply = assistant.reply("How to make a hamburger?")

p reply.role
# => "assistant"

p reply.content
# => "I don't know."

p reply.references
# [#<Recipe:0x000...>, ...]

p assistant.messages
# => [#<ActivePinecone::Message:0x000...>, ...]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/moekidev/active_pinecone. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/active_pinecone/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ActivePinecone project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/active_pinecone/blob/main/CODE_OF_CONDUCT.md).
