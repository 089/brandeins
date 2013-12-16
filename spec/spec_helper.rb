require 'byebug' if defined? ByeBug
require 'webmock/rspec'
require_relative 'support/capture_stdout'

module HelperMethods
  @@_FIXTURES = Hash.new

  def load_fixture(name)
    @@_FIXTURES[name] ||= load_fixture_from_disk(name)
  end

  def load_fixture_from_disk(name)
    fixture_path = File.expand_path("../support/fixtures/#{name}", __FILE__)
    File.read(fixture_path)
  end

  def require_lib(path)
    require_relative "../lib/#{path}"
  end

end

include HelperMethods
