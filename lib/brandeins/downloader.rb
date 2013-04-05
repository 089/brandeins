# encoding: utf-8
require_relative 'parser/article_site'
require_relative 'parser/magazine_site'
require_relative 'parser/archive_site'
require_relative 'merger/pdf_tools'

require 'net/http'
require 'prawn'

module BrandEins
  class Downloader

    def initialize(path, opts = {})
      $BE_VERBOSE = !!opts[:verbose]

      @url     = opts[:base_url] || 'http://www.brandeins.de'
      @dl_dir  = opts[:path]     || path

      @tmp_dir = @dl_dir + '/brand-eins-tmp'
      @pdftool = BrandEins::Merger::PdfTools.get_pdf_tool
      @archive = BrandEins::Parser::ArchiveSite.new(@url, opts)
      # should be lazily done, or?
      create_tmp_dirs
    end

    def get_magazines_of_year(year = 2000)
      puts "Getting all brand eins magazines of #{year}. This may take a while..." if $BE_VERBOSE
      magazine_links_per_year = @archive.get_magazine_links_by_year(year)
      magazine_links_per_year.each_with_index do |magazine_link, index|
        volume = index+1
        puts "Parsing Volume #{volume} of #{year}" if $BE_VERBOSE
        target_pdf = pdf_filename(year, volume)
        get_magazine_by_link(magazine_link, target_pdf, year, volume)
      end
    end

    def get_magazine(year = 2000, volume = 1)
      # doesnt handle edge cases
      # a) there is no volume
      puts "Parsing Volume #{volume} of #{year}" if $BE_VERBOSE
      target_pdf = pdf_filename(year, volume)
      magazine_links = @archive.get_magazine_links_by_year(year)
      magazine_link  = magazine_links[volume-1]
      get_magazine_by_link(magazine_link, target_pdf, year, volume)
    end

    private

    def create_tmp_dirs
      FileUtils.mkdir_p @tmp_dir unless File.directory?(@tmp_dir)
    end

    def create_cover_pdf(year, volume)
      puts "Creating cover for Volume #{volume} of #{year}" if $BE_VERBOSE
      cover = @archive.get_magazine_cover(year, volume)
      cover_title    = cover[:title]
      cover_img_url  = cover[:img_url]
      cover_img_file = @tmp_dir + "/cover-#{year}-#{volume}.jpg"
      cover_pdf_file = @tmp_dir + "/cover-#{year}-#{volume}.pdf"

      puts "Downloading cover image from #{cover_img_url} to #{cover_img_file}" if $BE_VERBOSE
      IO.binwrite(cover_img_file, Net::HTTP.get(URI(cover_img_url)))

      puts "Creating cover pdf #{cover_pdf_file} from #{cover_img_file}" if $BE_VERBOSE
      Prawn::Document.generate(cover_pdf_file) do |pdf|
        pdf.text "<font size='18'><b>" + cover_title + "</b></font>", :align => :center, :inline_format => true
        pdf.image cover_img_file, :position => :center, :vposition => :center
      end

      return cover_pdf_file
    end

    def get_magazine_by_link(target_magazine_link, target_pdf, year, volume)
      pdf_links = @archive.magazine_pdf_links(target_magazine_link)
      pdf_files = download(pdf_links)

      pdf_cover = create_cover_pdf(year, volume)
      pdf_files = pdf_files.unshift(pdf_cover)

      if @pdftool
        target_pdf_path = "#{@dl_dir}/#{target_pdf}"
        @pdftool.merge_pdf_files(pdf_files, target_pdf_path) && cleanup
      else
        puts 'brandeins wont merge the single pdf files since it didnt find an appropriate pdf tool' if $BE_VERBOSE
      end
    end

    def pdf_filename(year, volume)
      "Brand-Eins-#{year}-#{volume}.pdf"
    end

    def download(pdf_links)
      pdf_links.each_with_object([]) do |pdf_link, pdf_files|
        pdf_filename = @tmp_dir + '/' + File.basename(pdf_link)
        pdf_url = pdf_link
        download_pdf(pdf_url, pdf_filename) and pdf_files << pdf_filename
      end
    end

    def download_pdf(pdf_url, pdf_filename)
      if File.exists? pdf_filename
        puts "File #{pdf_filename} seems to be already downloaded" if $BE_VERBOSE
        return true
      end

      puts "Downloading PDF from #{pdf_url} to #{pdf_filename}" if $BE_VERBOSE
      begin
        IO.binwrite(pdf_filename, Net::HTTP.get(URI(pdf_url)))
      rescue
        return false
      end
    end

    def cleanup
      FileUtils.rm_r @tmp_dir
    end

  end

end
