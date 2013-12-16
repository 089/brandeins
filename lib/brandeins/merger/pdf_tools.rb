# encoding: utf-8

require_relative 'external/base'
require_relative 'external/pdftk'
require_relative 'external/ghostscript_windows'

module BrandEins
  module Merger
    class PdfTools

      class << self
        def get_pdf_tool(env = {})
          env = env || {}
          env[:os] ||= RUBY_PLATFORM
          get_klass_for_external(env).new
        end

        def get_klass_for_external(env)
          if env[:os].include? 'w32'
            BrandEins::Merger::External::GhostscriptWindows
          else
            BrandEins::Merger::External::Pdftk
          end
        end
      end

    end
  end
end
