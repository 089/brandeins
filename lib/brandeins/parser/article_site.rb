# encoding: utf-8
require 'nokogiri'

module BrandEins
  module Parser
    class ArticleSite

      def initialize(url)
        @url = url
      end

      def doc
        @doc || @doc = Nokogiri::HTML(open(@url))
      end

      def get_pdf_link
        puts "Parsing Article: #{@url}"
        link = doc.css("div#sidebar ul li#downloaden a")
        link[0] and link[0]['href']
      end

    end

  end
end
