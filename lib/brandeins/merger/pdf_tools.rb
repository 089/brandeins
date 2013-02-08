# encoding: utf-8
require 'brandeins/merger/extensions'
require 'brandeins/merger/templates/base'
require 'brandeins/merger/templates/osx'
require 'brandeins/merger/templates/pdftk_osx'
require 'brandeins/merger/templates/windows'
require 'brandeins/merger/templates/ghostscript_windows'

module BrandEins
  module Merger
    class PdfTools

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
