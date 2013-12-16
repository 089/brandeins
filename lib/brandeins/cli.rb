# encoding: utf-8

require 'optparse'
require 'ostruct'
require 'singleton'

require_relative '../brandeins'
require_relative '../brandeins/utils/cli_option_parser'

module BrandEins
  class Cli
    include Singleton

    def self.run(args)
      @@args = args
      instance.run
    end

    def initialize(args = ARGV)
      @args = (@@args || args).dup
    end

    def run
      options = BrandEins::Utils::CliOptionParser.parse(@args)
      abort 'Unknown command' unless %w[help version download].include? options.cmd
      send options.cmd, options
    end

    def version(opts = {})
      puts BrandEins::VERSION
    end

    def help(opts = {})
      puts BrandEins::Utils::CliOptionParser.parser
    end

    def download(opts = {})
      errors = validate_options(opts)
      abort errors.join("\n") if errors.size > 0

      month = opts.fetch(:month)
      year  = opts.fetch(:year)
      kiosk = BrandEins::Kiosk.new(opts)
      kiosk.download_magazine(month, year)
    rescue BrandEins::Utils::Fetcher::ContentNotFetchedError => e
      puts "Download Error: #{e}\n\n"
      puts "#{e.backtrace.join('\n')}"
    end

    def validate_options(options)
      [].tap do |errors|
        if !valid_month?(options.month)
          errors.push('Invalid month: Must be between 1 and 12')
        end
        if !valid_year?(options.year)
          errors.push("Invalid year: Must be between 2000 and #{Time.now.year}")
        end
      end
    end

    def valid_month?(month)
      (1..12).include? month
    end

    def valid_year?(year)
      (2000..Time.now.year).include? year
    end

  end
end
