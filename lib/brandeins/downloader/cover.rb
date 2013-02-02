# encoding: utf-8
require 'prawn'

module BrandEins
  module Downloader

    class Cover

      def create_cover_pdf(year, volume)
        cover = @archive.get_magazine_cover(year, volume)
        cover_title = cover[:title]
        cover_img_url  = cover[:img_url]
        cover_img_file = @tmp_dir + "/cover-#{year}-#{volume}.jpg"
        cover_pdf_file = @tmp_dir + "/cover-#{year}-#{volume}.pdf"

        File.open(cover_img_file,'w') do |f|
          uri = URI.parse(cover_img_url)
          Net::HTTP.start(uri.host, uri.port) do |http|
            http.request_get(uri.path) do |res|
              res.read_body do |seg|
                f << seg
        #hack -- adjust to suit:
                sleep 0.005
              end
            end
          end
        end

        Prawn::Document.generate(cover_pdf_file) do |pdf|
          pdf.text "<font size='18'><b>" + cover_title + "</b></font>", :align => :center, :inline_format => true
          pdf.image cover_img_file, :position => :center, :vposition => :center
        end
        return cover_pdf_file
      end

    end

  end
end
