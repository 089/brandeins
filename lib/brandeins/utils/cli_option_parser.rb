require 'ostruct'

module BrandEins
  class CliOptionParser
    def self.parse(args = ARGV)
      options = OpenStruct.new
      opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: brandeins download --month n --year n"
        opts.separator ""

        opts.on('-m MONTH', '--month month', Integer, "The publication month of the magazine. E.g. for may: '5'") do |month|
          options.month = month
        end

        opts.on('-y YEAR', '--year YEAR', Integer, "The publication year of the magazine. E.g. the current year '#{Time.now.year}'") do |year|
          options.year = year
        end

        opts.on('--path [PATH]', 'The path where to download the magazine to. Default is the current directory.') do |path|
          options.path = path
        end

        opts.on('-h', '--help', 'Show this message') do |help|
          options.help = help
        end

        opts.on('-v', '--verbose', 'Be verbose') do |verbose|
          options.verbose = verbose
        end

        opts.on('--version', 'Show the version') do |version|
          options.version = version
        end
      end

      opt_parser.parse!(args)
      options
    end
  end
end
