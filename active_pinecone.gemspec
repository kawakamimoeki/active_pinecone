# frozen_string_literal: true

require_relative 'lib/active_pinecone/version'

Gem::Specification.new do |spec|
  spec.name = 'active_pinecone'
  spec.version = ActivePinecone::VERSION
  spec.authors = ['Moeki Kawakami']
  spec.email = ['me@moeki.dev']

  spec.summary = 'ActiveRecord-esque base class that lets you use Pinecone.'
  spec.description = 'ActiveRecord-esque base class that lets you use Pinecone.'
  spec.homepage = 'https://github.com/moekidev/active_pinecone' 
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/moekidev/active_pinecone'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 5.0.0'
  spec.add_dependency 'pinecone', '~> 0.1.5'
  spec.add_dependency 'ruby-openai', '~> 4.1.0'
  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
