# encoding: utf-8

require 'tempfile'
require 'prawn'

require_relative '../utils/fetcher'

module BrandEins
  module Pages
    class Cover

      def initialize(magazine)
        @magazine = magazine
      end

      def cover_image_url
        @magazine.cover_url
      end

      def cover_title
        @magazine.title
      end

      def to_pdf
        cover_image = download_cover_image
        cover_pdf   = create_cover_pdf(cover_image)
      end

      def download_cover_image
        fetcher.fetch(cover_image_url)
      end

      def create_cover_pdf(image)
        Prawn::Document.new do |pdf|
          pdf.text '<font size="18"><b>' + cover_title + '</b></font>',
                   align: :center,
                   inline_format: true
          if image
            pdf.image image, position: :center, vposition: :center
          end
        end.render
      end

      def save_to(path)
        @path = path
        File.open(file_path, 'w') do |file|
          file.write to_pdf
        end
        file_path
      end

      def file_path
        Pathname.new(@path) + file_name
      end

      def file_name
        "magazine-cover-#{@magazine.mont}-#{@magazine.year}.pdf"
      end

      def fetcher
        @fetcher ||= BrandEins::Utils::Fetcher.instance
      end

    end
  end
end
