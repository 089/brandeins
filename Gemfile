source "http://rubygems.org"

group :test do
  gem 'rspec'
  gem 'webmock'
  gem 'rerun'
  gem 'fakefs', require: 'fakefs/safe'
  gem 'byebug'
  gem 'rubocop'
  if RUBY_VERSION.split('.').first.to_i > 1
    gem 'byebug'
  end
end

gemspec
