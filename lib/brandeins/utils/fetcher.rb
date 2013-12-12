# encoding: utf-8

require 'uri'
require 'net/http'
require 'singleton'
require 'pathname'
require 'digest/md5'

require_relative '../config'
require_relative 'cli_output'

module BrandEins
  module Utils

    class Fetcher
      include Singleton

      def initialize
        @cache = {}
      end

      def fetch(url)
        if cache_has_file?(url)
          cli.debug "Fetching file from cache: #{url}" do
            file_from_cache(url)
          end
        else
          cli.debug "Fetching file from url: #{url}" do
            http_get_resource(url)
          end
        end
      end

      class ContentNotFetchedError < StandardError; end

      def http_get_resource(url)
        cli.info "Fetching: #{url}" do
          uri  = URI.parse(url)
          resp = Net::HTTP.get_response(uri)
          unless resp.class == Net::HTTPOK
            raise ContentNotFetchedError, "Received #{resp.code}: #{resp.msg}"
          end
          write_to_cache(url, resp.body)
          return resp.body
        end
      end

      def write_to_cache(file_name, file_content)
        file_path = cache_path_for_file_name(file_name)
        cli.debug "Writing file to cache: #{file_path}" do
          !!File.binwrite(file_path, file_content)
        end
      end

      def file_from_cache(file_name)
        file_path = cache_path_for_file_name(file_name)
        @cache[file_path] ||= File.binread(file_path)
      end

      def cache_has_file?(file_name)
        file_path = cache_path_for_file_name(file_name)
        @cache.has_key?(file_path) || File.exists?(file_path)
      end

      def cache_path_for_file_name(file_name)
        cache_path + fingerprint_for_file_name(file_name)
      end

      def cache_path
        BrandEins::Config['cache_path']
      end

      def fingerprint_for_file_name(file_name)
        Digest::MD5.hexdigest(file_name)
      end

      def cli
        @cli ||= BrandEins::Utils::CliOutput.instance
      end

    end
  end
end
