module BrandEins
  module PdfTools
    attr_reader :pdf_tools, :pdf_tool

    def self.get_pdf_tool(env)
      if env.nil?
        @env[:os] = RUBY_PLATFORM
      else
        @env = env
      end

      @pdf_tools ||= _init_pdf_tools
      @pdf_tool ||= @pdf_tools.first.new if @pdf_tools.length > 0
    end

    class Template
      attr_accessor :cmd, :args, :cmd_path

      def available?
        _cmd_available? @cmd
      end

      def merge_pdf_files(pdf_files, target_pdf)
        begin
          puts "args: #{@args}"
          arg_files = pdf_files.join " "
          args = self.args.gsub(/__pdf_files__/, arg_files).gsub(/__target_pdf__/, target_pdf)
          puts "executing: #{@cmd} #{args}"
          open("|#{@cmd} #{args}").close
        rescue Exception => e
          puts "error: #{e.inspect}"
          return false
        end
        return true
      end

      private
      def _cmd_available? (cmd)
        begin
          open("|#{cmd}").close
        rescue Exception
          return false
        end
        return true
      end
    end

    class TemplateWin < Template; end
    class TemplateOSX < Template; end

    class PdftkOSX < TemplateOSX
      def initialize
        @cmd  = 'pdftk2'
        @args = '__pdf_files__ output __target_pdf__'
      end
    end

    class GhostscriptWin < TemplateWin
      def initialize
        @cmd  = 'gswin64c.exe'
        @args = ' -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=__target_pdf__ __pdf_files__'
      end
    end

    private
    def self._init_pdf_tools
      @pdf_tools = Array.new
      if @env[:os].include? 'w32'
        return _get_subclasses TemplateWin
      elsif @env[:os].include? 'darwin'
        return _get_subclasses TemplateOSX
      else
        return nil
      end
    end

    def self._get_subclasses(klass)
      classes = []
      klass.subclasses.each do |sklass|
        classes << sklass.new
      end
    end
  end
end

class Class
  def subclasses
    ObjectSpace.each_object(Class).select { |klass| klass < self }
  end
end