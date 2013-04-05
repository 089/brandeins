# encoding: utf-8
require 'nokogiri'
require 'net/http'

module BrandEins
  module Parser
    class MagazineSite

      def initialize(url, base_url)
        @url, @base_url = url, base_url
      end

      def doc
        @doc ||= Nokogiri::HTML(html)
      end

      def html
        @html ||= Net::HTTP.get(URI(@url))
      end

      def get_magazine_pdf_links
        puts "Parsing #{@url}" if $BE_VERBOSE
        [get_editorial_article_links, get_schwerpunkt_article_links].flatten
      end

      def get_schwerpunkt_article_links
        get_links("div.articleList ul h4 a")
      end

      def get_editorial_article_links
        get_links(".editorial-links li a")
      end

      def get_links(css_selector)
        link_nodes = doc.css(css_selector)
        link_nodes.each_with_object([]) do |node, links|
          article_link = @base_url + '/' + node['href']
          article  = BrandEins::Parser::ArticleSite.new(article_link)
          pdf_link = article.get_pdf_link
          if pdf_link.nil? and $BE_VERBOSE then
            puts "-------------------------------"
            puts "No Content for: #{article_link}"
            puts "-------------------------------"
          else
            links << @base_url + '/' + pdf_link
          end
        end
      end
    end

  end

end
