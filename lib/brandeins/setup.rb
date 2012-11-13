require File.expand_path '../pdf-tools', __FILE__

module BrandEins
  class Setup
    attr_reader :pdf_tool

    def initialize(env)
      @os = env[:os] || RUBY_PLATFORM
      @pdf_tool = env[:pdf_tool] || BrandEins::PdfTools.get_pdf_tool(env)
    end

    def run
      puts 'Checking requirements for your system'
      if @pdf_tool.available?
        puts "\nIt seems you have #{@pdf_tool.cmd} running on your system. You are ready to go!"
      else
        puts "\nIt seems you are missing a working pdf utility on your system. Use `brandeins setup help` to get help."
      end
    end

    def help
      if @os.include? 'darwin'
        puts 'In order to use brandeins gem on OS X you have to install pdftk.'
        puts 'You can find the binaries for pdftk here: http://www.pdflabs.com/docs/install-pdftk/'
        puts ''
        puts 'After this, run `brandeins setup` again.'
      elsif @os.include? 'w32'
        puts 'In order to use brandeins gem on Windows you have to install ghostscript: http://www.ghostscript.com/download/'
        puts 'After installing ghoscript you have to put the installation path of the bin folder containing "gswin64c.exe"'
        puts 'into your PATH environment variable. Here a quick how-to for achieving this: http://www.computerhope.com/issues/ch000549.htm'
        puts ''
        puts 'After this, run `brandeins setup` again.'
      else
        puts 'Your operating system seems to be not supported. Contact the gem author for more information: me@grekko.de'
      end
    end

  end
end