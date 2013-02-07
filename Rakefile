require 'bundler/gem_tasks'
require 'rake/testtask'
require './lib/brandeins/version'

Rake::TestTask.new do |t|
  t.test_files = FileList['test/*_test.rb', 'specs/*_spec.rb']
  t.verbose    = true
end

task :install do
  sh "gem install ./pkg/brandeins-#{BrandEins::VERSION}.gem"
end

task publish: [ :build ] do
  version = BrandEins::VERSION
  sh "gem push ./pkg/brandeins-#{BrandEins::VERSION}.gem"
end

rule /^version:bump:(major|minor|patch)/ do |t|
  sh "git status | grep 'nothing to commit'"
  index = ['major', 'minor','patch'].index(t.name.split(':').last)
  file = 'lib/brandeins/version.rb'

  version_file = File.read(file)
  old_version, *version_parts = version_file.match(/(\d+)\.(\d+)\.(\d+)/).to_a
  version_parts[index] = version_parts[index].to_i + 1
  version_parts[2] = 0 if index < 2
  version_parts[1] = 0 if index < 1
  new_version = version_parts * '.'
  File.open(file,'w'){|f| f.write(version_file.sub(old_version, new_version)) }

  sh "git add #{file} Gemfile.lock && git commit -m 'bump version to #{new_version}'"
end

task :default => :test
