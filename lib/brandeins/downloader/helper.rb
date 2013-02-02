# encoding: utf-8

module BrandEins
  module Downloader

    class Helper
      def initialize(dl_dir)
        @dl_dir = dl_dir
      end

      def download(pdf_links)
        pdf_links.each_with_object([]) do |pdf_link, pdf_files|
          pdf_filename = @dl_dir + '/' + File.basename(pdf_link)
          pdf_url = pdf_link
          download_pdf(pdf_url, pdf_filename)
          pdf_files << pdf_filename
        end
      end

      private
      def download_pdf(pdf_url, pdf_filename)
        if File.exists? pdf_filename
          puts "File #{pdf_filename} seems to be already downloaded" and return true
        end

        puts "Downloading PDF from #{pdf_url} to #{pdf_filename}"
        File.open(pdf_filename,'wb') do |new_file|
          # TODO: this is still weird
          open(pdf_url, 'rb') do |read_file|
            new_file.write(read_file.read)
          end
        end
      end
    end

  end
end
