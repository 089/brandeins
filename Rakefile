require 'bundler/gem_tasks'
require 'rake/testtask'
require './lib/brandeins/version'

Rake::TestTask.new do |t|
  t.test_files = FileList['test/*_test.rb', 'specs/*_spec.rb']
  t.verbose = true
end

task :install do
  sh "gem install ./pkg/brandeins-#{BrandEins::VERSION}.gem"
end

task publish: [ :build ] do
  version = BrandEins::VERSION
  sh "gem push ./pkg/brandeins-#{BrandEins::VERSION}.gem"
end

task :default => :test
