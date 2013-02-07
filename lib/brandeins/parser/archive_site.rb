# encoding: utf-8
require 'nokogiri'
require 'net/http'

module BrandEins
  module Parser
    class ArchiveSite

      def initialize(base_url, opts = {})
        @base_url    = base_url
        @archive_url = @base_url + "/archiv.html"
        if html = opts[:html]
          @doc = Nokogiri::HTML(html)
        end
      end

      def doc
        @doc || @doc = Nokogiri::HTML(Net::HTTP.get(URI(@archive_url)))
      end

      def get_magazine_links_by_year(year = 2000)
        puts "Loading Magazine from year #{year}" if $BE_VERBOSE
        magazine_nodes_with_meta = doc.css(".jahrgang-#{year} ul li")
        magazine_nodes_with_meta.each_with_object([]) do |node, links|
          if node['id'].nil? then
            link = node.css('a')
            if link[0].nil? then
              next
            end
            href = link[0]['href']
            links << @base_url + '/' + href
          end
        end
      end

      def get_magazine_cover(year, volume)
        title   = doc.css("#month_detail_#{year}_#{volume} .titel").children[0].to_s
        img_url = ''
        doc.css("#month_detail_#{year}_#{volume} .cover a img").each do |node|
          img_url = node['src']
        end
        return { :title => title, :img_url => @base_url + '/' + img_url }
      end

      def magazine_pdf_links(url)
        magazine = BrandEins::Parser::MagazineSite.new(url, @base_url)
        magazine.get_magazine_pdf_links
      end

    end

  end

end
