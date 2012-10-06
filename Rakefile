require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = 'test/*_test.rb'
end

task :build do
  sh 'gem build brandeins-dl.gemspec'
end

task :publish do
  require 'lib/brandeins-dl/version'
  version = BrandEins::VERSION
  sh "gem push brandeins-dl-#{version}.gem"
end