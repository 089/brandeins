require 'pathname'
require 'fileutils'

require_relative 'config'
require_relative 'utils/fetcher'
require_relative 'pages/archive'
require_relative 'pages/archive'
require_relative 'pages/cover'
require_relative 'merger/pdf_tools'

module BrandEins
  # Usage of
  class Kiosk
    attr_reader :target_path

    class InvalidPathError < StandardError; end

    def initialize(opts = {})
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

    def download_magazine(month: nil, year: nil)
      magazine           = fetch_magazine(month: month, year: year)
      cover_pdf_path     = download_cover(magazine)
      article_pdf_paths  = download_article_pdfs(magazine)
      magazine_pdf_files = article_pdfs.unshift(cover_pdf)
      merge_pdf_files(magazine_pdf_files)
    end

    def merge_pdf_files(pdf_files)
      magazine_file_path = magazine_file_path(month: month, year: year)
      merger.merge_pdf_files(pdf_files, magazine_file_path)
      clear_temp_path
      magazine_file_path
    end

    def download_article_pdfs(magazine)
      magazine.save_articles_to(temp_path)
    end

    def download_cover(magazine)
      cover = BrandEins::Pages::Cover.new(magazine)
      cover.save_to(temp_path)
    end

    def fetch_magazine(month: nil, year: nil)
      archive.magazine_for(month: month, year: year)
    end

    def magazine_file_path(month: nil, year: nil)
      Pathname.new(@target_path) + "brandeins-#{month}-#{year}.pdf"
    end

    def clear_temp_path
      FileUtils.rm Dir["#{temp_path}/*.pdf"]
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
