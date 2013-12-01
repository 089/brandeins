# encoding: utf-8

require 'nokogiri'

require_relative '../config'

module BrandEins
  module Pages
    class Article

      def initialize(html)
        @html = html
      end

      def pdf_url
        if node = document.css('a[href$=pdf]').first
          brandeins_url + '/' + node['href']
        end
      end

      def brandeins_url
        BrandEins::Config['base_uri']
      end

      private

      def document
        @document ||= Nokogiri::HTML(@html)
      end

    end
  end
end
