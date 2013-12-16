# encoding: utf-8

module BrandEins
  module Merger
    module External

      class Pdftk < BrandEins::Merger::External::Base

        def cmd
          'pdftk'
        end

        def args
          %w[ __pdf_files__ output __target_pdf__ ]
        end

        def noop
          %w[ --version ]
        end

      end

    end
  end
end
