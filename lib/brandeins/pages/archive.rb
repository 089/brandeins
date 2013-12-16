# encoding: utf-8

require 'nokogiri'
require 'english'

require_relative '../config'
require_relative '../pages/magazine'

module BrandEins
  module Pages
    # Usage of +Archive+
    #
    # page = Archive.new(html)
    # page.magazines_for_year(2000)
    # => [Magazine, Magazine, ...]
    #
    # page.magazine_for(month: 1, year: 2000)
    # => Magazine
    #
    # page.magazine_for(month: 13, year: 9999)
    # => nil
    #
    class Archive
      attr_reader :html

      def initialize(opts = {})
        @html = opts.fetch(:html, nil)
        @magazines = {}
      end

      def html
        cli.info 'Loading the archive' do
          @html ||= fetcher.fetch(archive_url)
        end
      rescue BrandEins::Utils::Fetcher::ContentNotFetchedError => e
        message = 'Could not download the archiv.html (Maybe the URL changed?)'
        raise e, message + "\n=> Original error: #{e.message}", e.backtrace
      end

      def magazines_for_year(year)
        @magazines[year] ||= parse_magazines_for_year(year)
      end

      def magazine_for(month, year)
        magazines_for_year(year)[month]
      end

      def document
        @document ||= Nokogiri::HTML(html)
      end

      def parse_magazines_for_year(year)
        anchor = document.css("h3#anchor-#{year}").first
        root   = anchor.xpath('../../..')
        root.css('article figure').each_with_object({}) do |figure, magazines|
          magazine_url   = extract_magazine_url(figure)
          magazine_month = extract_magazine_month(figure)
          magazine = BrandEins::Pages::Magazine.new(url: magazine_url)
          magazines[magazine_month] = magazine
        end
      end

      def extract_magazine_url(figure)
        brandeins_url + '/' + figure.css('a.read.more').first['href']
      end

      def extract_magazine_month(figure)
        meta = figure.css('.meta').first
        meta.text.match(/(?:.+)(\d{2})\/(?:.+)/) && $LAST_PAREN_MATCH.to_i
      end

      def brandeins_url
        BrandEins::Config['base_uri']
      end

      def archive_url
        BrandEins::Config['archive_uri']
      end

      def fetcher
        @fetcher ||= BrandEins::Utils::Fetcher.instance
      end

      def cli
        @cli ||= BrandEins::Utils::CliOutput.instance
      end

    end
  end
end
