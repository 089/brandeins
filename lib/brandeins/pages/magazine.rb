# encoding: utf-8

require 'nokogiri'

require_relative '../config'
require_relative '../utils/fetcher'
require_relative '../utils/cli_output'
require_relative '../pages/article'

module BrandEins
  module Pages
    # Usage of +MagazinePage+
    #
    # page = BrandEins::Parser::MagazinePage.new(html)
    # page.article_pdf_urls
    # => ['http://example.com/archive/article1.pdf',
    #     'http://example.com/archive/article2.pdf',
    #     ...
    #    ]
    #
    # page.cover_url
    # => 'http://example.com/archive/cover1.png'
    #
    class Magazine

      def initialize(opts = {})
        opts = { html: opts } if opts.is_a? String
        @html = opts[:html]
        @url  = opts[:url]
      end

      def html
        @html ||= fetcher.fetch(url)
      end

      def article_urls
        @article_urls ||= parse_article_urls
      end

      def article_pdf_urls
        @article_pdf_urls ||= article_urls.map do |article_url|
          article_html = fetcher.fetch(article_url)
          article = BrandEins::Pages::Article.new(article_html)
          article.pdf_url or cli.info "No PDF for: \"#{article.title}\""
        end.compact
      end

      def cover_url
        @cover_url ||= parse_cover_image_url
      end

      def title
        @title ||= document.css('.current-issue h2').children.first.text
      end

      def year
        @year ||= parse_year
      end

      def month
        @month ||= parse_month
      end

      def url
        @url ||= parse_url
      end

      def document
        @document ||= Nokogiri::HTML(html)
      end

      def parse_article_urls
        document.css('.ihv_list > a').each_with_object([]) do |node, links|
          links << brandeins_url + '/' + node['href']
        end
      end

      def parse_cover_image_url
        img_tag = primary_cover_image || secondary_cover_image
        brandeins_url + '/' + img_tag.attributes['src'].text if img_tag
      end

      def secondary_cover_image
        document.css('.preparedTeaserImage img').first
      end

      def primary_cover_image
        document.css('.coverImage img').first
      end

      def parse_year
        issue_text.match(/Ausgabe (?:.+)\/(.+)/) and $+.to_i
      end

      def parse_month
        issue_text.match(/Ausgabe (.+)\/(?:.+)/) and $+.to_i
      end

      def issue_text
        node = document.css('.current-issue h3').last
        node.children.first.text
      end

      def parse_url
        document.css('[property="og:url"]').first.attributes['content'].value
      end

      def brandeins_url
        BrandEins::Config['base_uri']
      end

      def fetcher
        @fetcher ||= BrandEins::Utils::Fetcher.instance
      end

      def save_articles_to(path)
        article_pdf_urls.each_with_object([]) do |pdf_url, pdf_files|
          pdf = fetcher.fetch(pdf_url)
          file_path = file_path_for_pdf(path, pdf_url)
          File.binwrite(file_path, pdf)
          pdf_files << file_path
        end
      end

      def file_path_for_pdf(path, pdf_url)
        target_path = Pathname.new(path)
        target_path.mkpath
        target_path + file_name_for_pdf_url(pdf_url)
      end

      def file_name_for_pdf_url(pdf_url)
        uri_path = URI(pdf_url).path
        File.basename(uri_path)
      end

      def cli
        @cli ||= BrandEins::Utils::CliOutput.instance
      end

    end
  end
end
