require 'bundler/gem_tasks'
require 'rake/testtask'
require './lib/brandeins/version'

Rake::TestTask.new do |t|
  t.pattern = 'test/*_test.rb'
end

task :build do
  sh 'gem build brandeins.gemspec'
end

task :publish do
  version = BrandEins::VERSION
  sh "gem push brandeins-#{version}.gem"
end

task :default => :test
