# encoding: utf-8
require File.expand_path('../downloader/helper', __FILE__)
require File.expand_path('../downloader/cover', __FILE__)
require File.expand_path('../parser/article_site', __FILE__)
require File.expand_path('../parser/magazine_site', __FILE__)
require File.expand_path('../parser/archive_site', __FILE__)
require File.expand_path('../merger/pdf_tools', __FILE__)

module BrandEins

  class Downloader

    def initialize(path)
      @url     = 'http://www.brandeins.de'
      @dl_dir  = path
      @tmp_dir = @dl_dir + '/brand-eins-tmp'
      @pdftool = BrandEins::Merger::PdfTools.get_pdf_tool
      @archive = BrandEins::Parser::ArchiveSite.new(@url)
      create_tmp_dirs
    end

    def get_magazines_of_year(year = 2000)
      puts "Getting all brand eins magazines of #{year}. This may take a while..."
      magazine_links_per_year = @archive.get_magazine_links_by_year(year)
      magazine_links_per_year.each_with_index do |magazine_link, index|
        volume = index+1
        puts "Parsing Volume #{volume} of #{year}"
        target_pdf = pdf_filename(year, volume)
        get_magazine_by_link(magazine_link, target_pdf, year, volume)
      end
    end

    def get_magazine(year = 2000, volume = 1)
      puts "Parsing Volume #{volume} of #{year}"
      target_pdf = pdf_filename(year, volume)
      magazine_links = @archive.get_magazine_links_by_year(year)
      magazine_link  = magazine_links[volume-1]
      get_magazine_by_link(magazine_link, target_pdf, year, volume)
    end

    private
    def create_tmp_dirs
      FileUtils.mkdir_p @tmp_dir unless File.directory?(@tmp_dir)
    end

    def get_magazine_by_link(target_magazine_link, target_pdf, year, volume)
      pdf_links = @archive.magazine_pdf_links(target_magazine_link)
      pdf_files = pdf_downloader.download(pdf_links)

      pdf_cover = create_cover_pdf(year, volume)
      pdf_files = pdf_files.reverse.push(pdf_cover).reverse

      if !@pdftool.nil?
        target_pdf_path = "#{@dl_dir}/#{target_pdf}"
        @pdftool.merge_pdf_files(pdf_files, target_pdf_path)
        cleanup
      else
        puts 'brandeins wont merge the single pdf files since it didnt find an appropriate pdf tool'
      end
    end

    def pdf_filename(year, volume)
      "Brand-Eins-#{year}-#{volume}.pdf"
    end

    def pdf_downloader
      @pdf_downloader || @pdf_downloader = BrandEins::Downloader::Helper.new(@tmp_dir)
    end

    def cleanup
      FileUtils.rm_r @tmp_dir
    end

  end

end
