# encoding: utf-8

require 'uri'
require 'net/http'

require_relative '../config'

module BrandEins
  module Utils
  # Usage of Fetcher
  # httpf = BrandEins::Fetcher.new('http://example.com')
  # httpf.fetch '/resource-path/file.html'
  # => html source
  # filef = BrandEins::Fetcher.new('file:///User/foo')
  # filef.fetch('/some-image.png')
  # => ByteStream

    class Fetcher
      attr_accessor :cache

      def self.instance
        @@instance ||= new
      end

      def initialize
        @cache = {}
      end

      def fetch(url)
        cache.fetch(url) { fetch_resource(url) }
      end

      def fetch_resource(url)
        uri = URI.parse(url)
        Net::HTTP.get(uri)
      end

    end
  end
end
