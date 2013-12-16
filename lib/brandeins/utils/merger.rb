# encoding: utf-8

require 'singleton'
require 'prawn'

require_relative './cli_output'

module BrandEins
  module Utils
    # Testing Prawn for merging pdfs
    class Merger
      include Singleton

      def merge_pdf_files(pdf_file_paths, target_pdf)
        cli.info "Merging pdf files to: #{target_pdf}" do
          Prawn::Document.generate(target_pdf, pdf_options) do |pdf|
            pdf_file_paths.each do |pdf_file|
              if File.exists?(pdf_file)
                pdf_temp_nb_pages = Prawn::Document.new(template: pdf_file).page_count
                (1..pdf_temp_nb_pages).each do |i|
                  pdf.start_new_page(template: pdf_file, template_page: i)
                end
              end
            end
          end
        end
      end

      def pdf_options
        {
          page_size: 'A4',
          skip_page_creation: true
        }
      end

      def cli
        @cli ||= BrandEins::Utils::CliOutput.instance
      end
    end
  end
end
