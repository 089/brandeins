require 'pathname'

require_relative 'config'
require_relative 'utils/fetcher'
require_relative 'pages/archive'
require_relative 'pages/cover'
require_relative 'merger/pdf_tools'

require 'byebug'

module BrandEins
  # Usage of
  class Kiosk
    attr_reader :target_path

    class InvalidPathError < StandardError; end

    def initialize(opts = {})
      opts = opts.to_h
      @target_path = opts.fetch(:path) { Pathname.new('.').realpath.to_s }
      raise_if_path_inaccessible
      set_opts_for_cli_output(opts)
      create_directories_if_necessary
    end

    def create_directories_if_necessary
      cache_path.mkpath unless cache_path.exist?
      temp_path.mkpath unless temp_path.exist?
    end

    def set_opts_for_cli_output(opts)
      cli_output_opts = {}
      cli_output_opts[:debug] = !!opts[:verbose]
      cli.set_options(cli_output_opts)
    end

    def raise_if_path_inaccessible
      path = Pathname.new(@target_path)
      if !path.writable?
        raise InvalidPathError, 'Could not access the given path'
      end
    end

    def fetch_magazine(month: nil, year: nil)
      magazine = archive.magazine_for(month: month, year: year)
      cover = BrandEins::Pages::Cover.new(magazine)
      # 1. Download articles to temp path
      # 2. Create cover if possible
      # 2. Run pdf merge with target path
      article_pdfs = magazine.save_articles_to temp_path
      cover_pdf    = cover.save_to temp_path
      pdf_files    = article_pdfs.unshift(cover_pdf)
      merger.merge_pdf_files pdf_files, magazine_file_path(month: month, year: year)
    end

    def magazine_file_path(month: nil, year: nil)
      Pathname.new(@target_path) + "brandeins-#{month}-#{year}.pdf"
    end

    def merger
      @merger ||= BrandEins::Merger::PdfTools.get_pdf_tool
    end

    def temp_path
      BrandEins::Config['temp_path']
    end

    def cache_path
      BrandEins::Config['cache_path']
    end

    def archive
      @archive ||= BrandEins::Pages::Archive.new
    end

    def cli
      @cli ||= BrandEins::Utils::CliOutput.instance
    end

  end
end
