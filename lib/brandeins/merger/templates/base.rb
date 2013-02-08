# encoding: utf-8

module BrandEins
  module Merger
    module Templates

      class Base

        def available?
          _cmd_available? cmd, noop
        end

        def cmd;  raise "Must be implemtented by the subclasses"; end
        def noop; raise "Must be implemtented by the subclasses"; end
        def args; raise "Must be implemtented by the subclasses"; end

        def merge_pdf_files(pdf_files, target_pdf)
          begin
            pdf_files_arg = pdf_files.map {|pdf_file| "'#{pdf_file}'" }.join ' '
            args = self.args.join(' ').gsub(/__pdf_files__/, pdf_files_arg).gsub(/__target_pdf__/, target_pdf)
            puts "executing: #{cmd} #{args}"
            _exec("#{cmd} #{args}")
          rescue Exception => e
            puts "error: #{e.inspect}"
            return false
          end
          return true
        end

        private
        def _exec (cmd)
          IO.popen(cmd)
        end

        def _cmd_available? (cmd, args)
          begin
            open("|#{cmd} #{args.join(' ')}").close
          rescue Exception
            return false
          end
          return true
        end
      end

    end
  end
end
