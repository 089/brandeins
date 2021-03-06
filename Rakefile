require 'bundler/gem_tasks'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'

Rubocop::RakeTask.new
RSpec::Core::RakeTask.new(:spec)

task :load_version_file do
  require_relative './lib/brandeins/version'
end

task install: [ :load_version_file ] do
  sh "gem install ./pkg/brandeins-#{BrandEins::VERSION}.gem"
end

task publish: [ :load_version_file, :build ] do
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

task default: :spec
