%w(
  brandeins/version
  brandeins/setup
  brandeins/pdf-tools
  nokogiri
  open-uri
  uri
  fileutils
  thor
  prawn
).each do |lib|
  begin
    require lib
  rescue Exception => e
    puts "missing #{lib}, #{e.inspect}"
  end
end

module BrandEins

  class CLI < Thor
    map '--version' => :version

    desc '--version', 'Displays current version'
    def version
      puts BrandEins::VERSION
    end

    desc 'download', 'Download past brand eins magazines (use `brandeins help download` to learn more about options)'
    method_option :path, :type => :string
    method_option :volume, :type => :numeric
    method_option :all
    method_option :year, :type => :numeric
    def download
      path   = options.path || Dir.pwd
      year   = options.year || Time.new.year
      all    = options.all
      volume = options.volume

      if volume.nil? && all.nil?
        puts "If you want to download a specific volune use the --volume flag or use --all to download all volumes of a year"
      else
        b1 = BrandEins::Downloader.new path
        if !all.nil?
          b1.get_magazines_of_year year
        else
          b1.get_magazine year, volume
        end
      end
    end

    desc 'setup', 'Checks if all requirements for using brandeins gem are met'
    method_option :help
    def setup
      setup = BrandEins::Setup.new
      if !options.help.nil?
        setup.help
      else
        setup.run
      end
    end

    desc 'test', 'test some stuff'
    method_option :input, :type => :string
    method_option :output, :type => :string
    def test
      gs = BrandEins::PdfTools::GhostscriptWin.new
      if gs.available?
        puts "GS is available"
        if options.input.nil? || options.output.nil?
          puts "need input/output to merge files"
        else
          puts "input: #{options.input}, output: #{options.output}"
          BrandEins::PdfTools::GhostscriptWin.merge_pdf_files(options.input, options.output)
        end
      else
        puts "GS not found"
      end
    end
  end

  class Downloader
    attr_reader :archive

    def initialize(path)
      @url     = 'http://www.brandeins.de'
      @archive = false
      @dl_dir  = path
      @tmp_dir = path + '/brand-eins-tmp'
      @pdftool = BrandEins::PdfTools.get_pdf_tool
      create_tmp_dirs
    end

    def setup
      @archive = ArchiveSite.new @url
    end

    def get_magazines_of_year(year = 2000)
      setup
      puts "Getting all brand eins magazines of a #{year}. This could take a while..."
      magazine_links_per_year = @archive.get_magazine_links_by_year(year)
      magazine_links_per_year.each_with_index do |magazine_link, volume|
        puts "Parsing Volume #{volume} of #{year}"
        target_pdf = get_target_pdf(year, volume)
        get_magazine_by_link(magazine_link, target_pdf)
      end
    end

    def get_magazine(year = 2000, volume = 1)
      setup
      puts "Parsing Volume #{volume} of #{year}"
      target_pdf = get_target_pdf(year, volume)

      magazine_links = @archive.get_magazine_links_by_year(year)
      target_magazine_link = magazine_links[volume-1]

      get_magazine_by_link(target_magazine_link, target_pdf, year, volume)
    end

    private
    def create_tmp_dirs
      FileUtils.mkdir_p @tmp_dir unless File.directory?(@tmp_dir)
    end

    def get_magazine_by_link(target_magazine_link, target_pdf, year, volume)
      pdf_links = @archive.magazine_pdf_links(target_magazine_link)
      pdf_files = download_pdfs(pdf_links)

      pdf_cover = create_cover_pdf(year, volume)
      pdf_files = pdf_files.reverse.push(pdf_cover).reverse

      if !@pdftool.nil?
        @pdftool.merge_pdf_files(pdf_files, target_pdf)
        cleanup
      else
        if RUBY_PLATFORM.include? 'darwin'
          puts 'brandeins wont merge the single pdf files since it didnt find the pdftk tool'
        end
      end
    end

    def create_cover_pdf(year, volume)
      cover = @archive.get_magazine_cover(year, volume)
      cover_title = cover[:title]
      cover_img_url  = cover[:img_url]
      cover_img_file = @tmp_dir + "/cover-#{year}-#{volume}.jpg"
      cover_pdf_file = @tmp_dir + "/cover-#{year}-#{volume}.pdf"

      File.open(cover_img_file,'w') do |f|
        uri = URI.parse(cover_img_url)
        Net::HTTP.start(uri.host,uri.port) do |http|
          http.request_get(uri.path) do |res|
            res.read_body do |seg|
              f << seg
      #hack -- adjust to suit:
              sleep 0.005
            end
          end
        end
      end

      require 'prawn'
      Prawn::Document.generate(cover_pdf_file) do |pdf|
        pdf.text "<font size='18'><b>" + cover_title + "</b></font>", :align => :center, :inline_format => true
        pdf.image cover_img_file, :position => :center, :vposition => :center
      end
      return cover_pdf_file
    end

    def get_target_pdf(year, volume)
      "Brand-Eins-#{year}-#{volume}.pdf"
    end

    def download_pdfs(pdf_links)
      pdf_downloader = PDFDownloader.new(pdf_links, @tmp_dir)
      pdf_downloader.download_all
    end

    def cleanup
      FileUtils.rm_r @tmp_dir
    end

    class PDFDownloader

      def initialize(pdf_links, dl_dir)
        @dl_dir    = dl_dir
        @pdf_links = pdf_links
      end

      def download_all
        pdf_files = Array.new
        @pdf_links.each do |pdf_link|
          pdf_name = @dl_dir + '/' + File.basename(pdf_link)
          pdf_url = pdf_link
          download_pdf(pdf_url, pdf_name)
          pdf_files << pdf_name
        end
        pdf_files
      end

      private

      def download_pdf(pdf_url, filename)
        if File.exists? filename
          puts "File #{filename} seems to be already downloaded"
          return true
        end

        puts "Downloading PDF from #{pdf_url} to #{filename}"
        File.open(filename,'wb') do |new_file|
          open(pdf_url, 'rb') do |read_file|
            new_file.write(read_file.read)
          end
        end
      end

    end

    class ArchiveSite
      attr_accessor :doc

      def initialize(base_url, html = false)
        @base_url = base_url
        @archive_url = @base_url + "/archiv.html"
        if html
          @doc = Nokogiri::HTML(html)
        end
      end

      def setup
        return if defined?(@doc) != nil
        @doc = Nokogiri::HTML(open(@archive_url))
      end

      def get_magazine_links_by_year(year = 2000)
        setup
        puts "Loading Magazine from year #{year}"
        magazine_nodes_with_meta = @doc.css(".jahrgang-#{year} ul li")
        magazine_links = Array.new
        magazine_nodes_with_meta.each_with_index do |node, index|
          if node['id'].nil? then
            link = node.css('a')
            if link[0].nil? then
              next
            end
            href = link[0]['href']
            magazine_links << @base_url + '/' + href
          end
        end
        magazine_links
      end

      def get_magazine_cover(year, volume)
        title   = @doc.css("#month_detail_#{year}_#{volume} .titel").children[0].to_s
        img_url = ''
        @doc.css("#month_detail_#{year}_#{volume} .cover a img").each do |node|
          img_url = node['src']
        end
        return { :title => title, :img_url => @base_url + '/' + img_url }
      end

      def magazine_pdf_links(url)
        magazine = ArchiveMagazine.new(url, @base_url)
        magazine.get_magazine_pdf_links
      end

      class ArchiveMagazine
        attr_accessor :url, :doc

        def initialize(url, base_url, html = false)
          puts "Parsing #{url}"
          @url = url
          @base_url = base_url
          @doc = Nokogiri::HTML(open(url))
        end

        def get_magazine_pdf_links
          [get_editorial_article_links, get_schwerpunkt_article_links].flatten
        end

        def get_schwerpunkt_article_links
          get_links("div.articleList ul h4 a")
        end

        def get_editorial_article_links
          get_links(".editorial-links li a")
        end

        def get_links(css_selector)
          pdf_links = Array.new
          link_nodes = @doc.css(css_selector)
          link_nodes.each do |node|
            article_link = @base_url + '/' + node['href']
            article = MagazineArticle.new(article_link)
            pdf_link = article.get_pdf_link
            if pdf_link.nil? then
              puts "------------------------------"
              puts "No Content for: #{article_link}"
              puts "------------------------------"
            else
              pdf_links << @base_url + '/' + pdf_link
            end
          end
          pdf_links
        end

        class MagazineArticle
          attr_accessor :url, :doc

          def initialize(url)
            puts "Parsing Article: #{url}"
            @url = url
            @doc = Nokogiri::HTML(open(url))
          end

          def get_pdf_link
            link = @doc.css("div#sidebar ul li#downloaden a")
            if link[0].nil? then
              return nil
            else
              return link[0]['href']
            end
          end
        end
      end
    end
  end
end
