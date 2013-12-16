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
      options = BrandEins::CliOptionParser.parse(@args)
      if options.version
        puts BrandEins::VERSION
        return
      end
      if options.download
        path   = options.path
        month  = options.month
        year   = options.year
        errors = validate_options(options)
        puts errors.join("\n") && return unless error.empty?
        download(path: path, month: month, yeaR: year)
      end
    end

    def download(opts = {})
      path  = opts.fetch(:path)
      month = opts.fetch(:month)
      year  = opts.fetch(:month)
      kiosk = BrandEins::Kiosk.new(path: path)
      kiosk.fetch_magazine(month: month, year: year)
    rescue BrandEins::Utils::Fetcher::ContentNotFetchedError => e
      puts "Download Error: #{e}\n\n"
      puts "#{e.backtrace.join('\n')}"
    end

    def validate_options
      errors = []
      if !(1..12).include? @options.month
        errors.push("Invalid month: Must be between 1 and 12")
      end
      if !(2000..Time.now.year).include? @options.year
        errors.push("Invalid year: Must be between 2000 and #{Time.now.year}")
      end
      return errors
    end

  end
end
