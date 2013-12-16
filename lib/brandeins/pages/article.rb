# encoding: utf-8

require 'nokogiri'

require_relative '../config'

module BrandEins
  module Pages
    # Represents an article of a magazine
    class Article

      def initialize(html)
        @html = html
      end

      def pdf_url
        if node = document.css('a[href$=pdf]').first
          brandeins_url + '/' + node['href']
        end
      end

      def title
        if node = document.css('h2.csc-firstHeader').first
          node.children.first.text.gsub("\n", '')
        end
      end

      def document
        @document ||= Nokogiri::HTML(@html)
      end

      def brandeins_url
        BrandEins::Config['base_uri']
      end

    end
  end
end
