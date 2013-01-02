require 'bundler/gem_tasks'
require 'rake/testtask'
require './lib/brandeins/version'

Rake::TestTask.new do |t|
  t.pattern = 'test/*_test.rb'
end

task :install do
  sh "gem install ./pkg/brandeins-#{BrandEins::VERSION}.gem"
end

task :publish do
  version = BrandEins::VERSION
  sh "gem push brandeins-#{BrandEins::VERSION}.gem"
end

task :default => :test
