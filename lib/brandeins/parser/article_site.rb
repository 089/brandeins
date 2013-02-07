# encoding: utf-8
require 'nokogiri'
require 'net/http'

module BrandEins
  module Parser
    class ArticleSite

      def initialize(url)
        @url = url
      end

      def doc
        @doc || @doc = Nokogiri::HTML(Net::HTTP.get(URI(@url)))
      end

      def get_pdf_link
        puts "Parsing Article: #{@url}" if $BE_VERBOSE
        link = doc.css("div#sidebar ul li#downloaden a")
        link[0] and link[0]['href']
      end

    end

  end
end
