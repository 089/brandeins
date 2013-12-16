# encoding: utf-8

module BrandEins
  module Merger
    module External

      class GhostscriptWindows < BrandEins::Merger::External::Base

        def cmd
          'gswin64c.exe'
        end

        def args
          %w[ -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=__target_pdf__ __pdf_files__ ]
        end

        def noop
          %w[--version]
        end

      end

    end
  end
end
