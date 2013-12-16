# encoding: utf-8

require 'shellwords'

require_relative '../../utils/cli_output'

module BrandEins
  module Merger
    module External

      class Base

        def available?
          _cmd_available? cmd, noop
        end

        def cmd;  raise "Must be implemtented by the subclasses"; end
        def noop; raise "Must be implemtented by the subclasses"; end
        def args; raise "Must be implemtented by the subclasses"; end

        def merge_pdf_files(pdf_files, target_pdf)
          # TODO: This is terrible. Use shellwords.shellescape!
          begin
            pdf_files_arg = pdf_files.map {|pdf_file| "'#{pdf_file.to_s}'" }.join ' '
            args = self.args.join(' ').gsub(/__pdf_files__/, pdf_files_arg).gsub(/__target_pdf__/, "'#{target_pdf.to_s}'")
            cli.info "Running PDF Merger for #{target_pdf}"
            cli.debug "Executing: `#{cmd} #{args}`" do
              _exec("#{cmd} #{args}")
            end
          rescue Exception => e
            cli.error "Error when merging file: #{e.inspect}"
            return false
          end
          return true
        end

        def cli
          @cli ||= BrandEins::Utils::CliOutput.instance
        end

        def _exec (cmd)
          IO.popen(cmd) do |io|
            io.each do |line|
              puts line
            end
          end
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
