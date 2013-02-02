# encoding: utf-8
require File.expand_path('../extensions', __FILE__)
require File.expand_path('../templates/base', __FILE__)
require File.expand_path('../templates/osx', __FILE__)
require File.expand_path('../templates/pdftk_osx', __FILE__)
require File.expand_path('../templates/windows', __FILE__)
require File.expand_path('../templates/ghostscript_windows', __FILE__)

module BrandEins
  module Merger
    class PDFTools

      class << self
        def get_pdf_tool(env = nil)
          @env = env || {}
          @env[:os] ||= RUBY_PLATFORM

          init_pdf_tools and return_pdf_tool
        end

        private
        def init_pdf_tools
          template_group = choose_template_group
          @pdf_tools = get_subclasses template_group
        end

        def choose_template_group
          return BrandEins::Merger::Templates::Windows if @env[:os].include? 'w32'
          return BrandEins::Merger::Templates::OSX     if @env[:os].include? 'darwin'
        end

        def get_subclasses(klass)
          classes = []
          klass.subclasses.each do |sklass|
            classes << sklass.new
          end
        end

        def return_pdf_tool
          @pdf_tools.first.new if @pdf_tools.length > 0
        end

      end

    end
  end
end
