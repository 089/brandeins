source "http://rubygems.org"

group :test do
  if ENV['RUBY_VERSION'][5,3] == '1.8'
    gem 'minitest'
  end
  gem 'webmock'
  gem 'debugger'
  gem 'fakefs', require: 'fakefs/safe'
end

gemspec
