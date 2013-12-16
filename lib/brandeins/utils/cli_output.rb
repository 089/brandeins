# encoding: utf-8

require 'singleton'
require 'io/console'

module BrandEins
  module Utils
    # Used to print status messages to the cli
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
          info: true,
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

      def print(msg, opts = {})
        msg = conformize(msg) unless opts[:full_length]
        out.write(msg)
        out.flush
      end

      def println(msg, opts = {})
        msg += "\n" unless msg.end_with? "\n"
        print(msg, opts)
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
        msg[0, console_width - 12] + '…' + msg[msg.length - 6, 6]
      end

      def debug(msg, &block)
        println(msg, full_length: true) if debug?
        block.call if block_given?
      end

      def info(msg, &block)
        println msg if info?
        block.call if block_given?
      end

      def statusline(msg, &block)
        print msg if info?
        result = block.call if block_given?
        clear_line if info?
        result
      end

      def warning(msg)
        println msg if warning?
      end
    end
  end
end
