# encoding: utf-8
require 'thor'

module BrandEins
  class CLI < Thor
    map '--version' => :version

    desc '--version', 'Displays current version'
    def version
      puts BrandEins::VERSION
    end

    desc 'download', 'Download past brand eins magazines (use `brandeins help download` to learn more about options)'
    method_option :path, :type => :string
    method_option :volume, :type => :numeric
    method_option :all
    method_option :year, :type => :numeric
    def download
      path   = options.path ? File.expand_path(options.path) : Dir.pwd
      year   = options.year || Time.new.year
      all    = options.all
      volume = options.volume

      if volume.nil? and all.nil?
        puts "If you want to download a specific volune use the --volume flag or use --all to download all volumes of a year"
      else
        downloader = BrandEins::Downloader.new(path)
        if !all.nil?
          downloader.get_magazines_of_year year
        else
          downloader.get_magazine year, volume
        end
      end
    end

    desc 'setup', 'Checks if all requirements for using brandeins gem are met'
    method_option :help
    def setup
      setup = BrandEins::Setup.new
      if !options.help.nil?
        setup.help
      else
        setup.run
      end
    end
  end
end
