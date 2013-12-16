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

    # Used as a centralized resource fetcher with a caching mechanism
    class Fetcher
      include Singleton

      ContentNotFetchedError = Class.new StandardError

      def fetch(url)
        remove_oldest_cache_file if cache_limit_reached?
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

      def http_get_resource(url)
        cli.statusline "Fetching: #{url}" do
          uri  = URI.parse(url)
          resp = Net::HTTP.get_response(uri)
          unless resp.class == Net::HTTPOK
            raise ContentNotFetchedError, "Received #{resp.code}: #{resp.msg}"
          end
          write_to_cache(url, resp.body)
          resp.body
        end
      end

      def write_to_cache(file_name, file_content)
        cache_file_path = cache_path_for_file_name(file_name)
        cli.debug "Writing file to cache: #{cache_file_path}" do
          result = !!File.binwrite(cache_file_path, file_content)
          add_to_cache(file_name, file_content)
          return result
        end
      end

      def file_from_cache(file_name)
        cache_file_path = cache_path_for_file_name(file_name)
        cli.statusline "Reading file from cache: #{file_name}" do
          cache_file_path = cache_path_for_file_name(file_name)
          File.binread(cache_file_path)
        end
      end

      def cache_has_file?(file_name)
        cache_path = cache_path_for_file_name(file_name)
        cache_files.key? cache_path
      end

      def cache_path_for_file_name(file_name)
        cache_path + escaped_file_name(file_name)
      end

      def escaped_file_name(file_name)
        uri = URI.parse(file_name)
        [uri.host, File.basename(uri.path)].compact.join('-')
      end

      def cache_limit_in_bytes
        BrandEins::Config['cache_limit_bytes']
      end

      def cache_path
        BrandEins::Config['cache_path']
      end

      def cache_limit_reached?
        cache_size_in_bytes > cache_limit_in_bytes
      end

      def cache_size_in_bytes
        cache_files.reduce(0) do |sum, (file, _)|
          next unless file
          sum += File.size?(file) || 0
        end
      end

      def remove_oldest_cache_file
        oldest_file = cache_files.sort_by { |file, time| time }.last.first
        cli.debug "Removing cached file: #{oldest_file}" do
          FileUtils.rm oldest_file
          cache_files.delete(oldest_file)
        end
      end

      def add_to_cache(file_name, file_content)
        cache_file_path = cache_path_for_file_name(file_name)
        cache_files[cache_file_path.to_s] = File.mtime(cache_file_path)
      end

      def cache_files
        @cache_files ||= begin
                           files = Dir[cache_path + './*']
                           files_with_mtime = files.map do |file_path|
                             [file_path, File.mtime(file_path)]
                           end
                           Hash[files_with_mtime]
                         end
      end

      def cli
        @cli ||= BrandEins::Utils::CliOutput.instance
      end

    end
  end
end
