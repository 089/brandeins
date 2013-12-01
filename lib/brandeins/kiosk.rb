require 'pathname'

require_relative 'config'
require_relative 'utils/fetcher'
require_relative 'pages/archive'
require_relative 'merger/pdf_tools'

require 'byebug'

module BrandEins
  # Usage of
  class Kiosk
    attr_reader :path

    class InvalidPathError < StandardError; end

    def initialize(opts = {})
      @path = opts.fetch(:path) { Pathname.new('.').realpath.to_s }
      raise_if_path_inaccessible
    end

    def raise_if_path_inaccessible
      path = Pathname.new(@path)
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
      pdf_files    = article_pdfs << cover_pdf
      merger.merge_pdf_files pdf_files, magazine_file_path(month: month, year: year)
    end

    def magazine_file_path(month: nil, year: nil)
      Pathname.new(@path) + "brandeins-#{month}-#{year}.pdf"
    end

    def merger
      @merger ||= BrandEins::Merger::PdfTools.get_pdf_tool
    end

    def temp_path
      @temp_path ||= get_temp_path
    end

    def get_temp_path
      file = Tempfile.new
      path = Pathname.new(file.path)
      path.to_s
    end

    def archive
      @archive ||= BrandEins::Pages::Archive.new
    end

  end
end
