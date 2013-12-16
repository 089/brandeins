source "http://rubygems.org"

group :test do
  gem 'rspec'
  gem 'webmock'
  gem 'rubocop'
end

group :debug do
  if RUBY_VERSION.split('.').first.to_i > 1
    gem 'byebug'
  end
end

gemspec
