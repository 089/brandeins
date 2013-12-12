require 'singleton'
require 'io/console'

module BrandEins
  module Utils
    class CliOutput
      include Singleton

      def initialize
        @opts = {}
        @opts[:console_height], @opts[:console_width] = out.winsize
      end

      def out
        $stdout
      end

      def set_options(opts)
        @opts = default_opts.merge(opts)
      end

      def debug?
        @opts[:debug]
      end

      def info?
        @opts[:info]
      end

      def warning?
        @opts[:warning]
      end

      def error?
        @opts[:error]
      end

      def default_opts
        {
          info: false,
          warning: true,
          error: true,
          debug: false
        }
      end

      def clear_line
        out.write "\r"
        out.write "\e[K"
        out.flush
      end

      def print(msg)
        msg = conformize(msg)
        out.write msg
        out.flush
      end

      def print(msg)
        msg = conformize(msg)
        out.write msg
        out.flush
      end

      def println(msg)
        msg += "\n" unless msg.end_with? "\n"
        print msg
      end

      def console_width
        @opts[:console_width] || 80
      end

      def line_up
        out.write "\e[A"
        out.flush
      end

      def conformize(msg)
        return msg if msg.size < console_width
        msg[0, console_width-12] + "…" + msg[msg.length-6, 6]
      end

      def debug(msg, &block)
        if debug?
          println msg
        end
        if block_given?
          block.call
        end
      end

      def info(msg, &block)
        println msg
        if block_given?
          result = block.call
          clear_line
          result
        end
      end

      def warning(msg)
        if warning?
          clear_line
          print msg
        end
      end
    end
  end
end
