# encoding: utf-8

module BrandEins
  module Merger
    module Templates

      class PdftkOSX < BrandEins::Merger::Templates::OSX

        def cmd
          'pdftk'
        end

        def args
          ['__pdf_files__', 'output', '__target_pdf__']
        end

        def noop
          ['--version']
        end

      end

    end
  end
end
