# encoding: utf-8

require 'optparse'
require 'ostruct'

require 'brandeins'

module BrandEins
  class CLI
    def self.run
      new.run
    end

    def initialize
      @args = ARGV.dup
      @options = OpenStruct.new
      @options.run = false
      @option_parser = init_option_parser
    end

    def run
      @option_parser.parse!(@args)

      if !@options.year || !@options.month
        puts @option_parser
        exit
      end

      validate_options
      if !@options.errors.empty?
        puts @options.errors.join("\n")
      end

      @kiosk = BrandEins::Kiosk.new(@options)
      @kiosk.fetch_magazine(month: @options.month, year: @options.year)
      rescue BrandEins::Utils::Fetcher::ContentNotFetchedError => e
        puts "Download Error: #{e}\n\n"
        puts "#{e.backtrace.join('\n')}"
    end

    def validate_options
      @options.errors = []
      if !(1..12).include? @options.month
        @options.errors.push("Invalid month: Must be between 1 and 12")
      end
      if !(2000..Time.now.year).include? @options.year
        @options.errors.push("Invalid year: Must be between 2000 and #{Time.now.year}")
      end
    end

    def init_option_parser
      OptionParser.new do |opts|
        opts.banner = "Usage: brandeins download --month n --year n"
        opts.separator ""

        opts.on('-m MONTH', '--month month', Integer, "The publication month of the magazine. E.g. for may: '5'") do |month|
          @options.month = month
        end

        opts.on('-y YEAR', '--year YEAR', Integer, "The publication year of the magazine. E.g. the current year '#{Time.now.year}'") do |year|
          @options.year = year
        end

        opts.on('--path [PATH]', 'The path where to download the magazine to. Default is the current directory.') do |path|
          @options.path = path
        end

        opts.on('-h', '--help', 'Show this message') do
          puts opts
          exit
        end

        opts.on('-v', '--verbose', 'Be verbose') do |verbose|
          @options.verbose = verbose
        end

        opts.on('--version', 'Show the version') do
          puts BrandEins::VERSION
          exit
        end
      end
    end

  end
end

BrandEins::CLI.run
