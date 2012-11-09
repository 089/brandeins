module PDFTools
  module Helper
    def self.cmd_available? (cmd)
      begin
        open("|#{cmd}").close
      rescue Exception
        return false
      end
      return true
    end
  end

  class Template
    include PDFTools::Helper
    attr_reader :cmd, :args, :info

    def self.cmd(cmd)
      @cmd = cmd
    end

    def self.args(args)
      @args = args
    end

    def self.info(info)
      @info = info
    end

    def self.available?
      PDFTools::Helper.cmd_available? @cmd
    end

    def self.merge_pdf_files(pdf_files, target_pdf)
      begin
        arg_files = pdf_files.join " "
        args = @args.gsub(/__pdf_files__/, arg_files).gsub(/__target_pdf__/, target_pdf)
        puts "executing: #{@cmd} #{args}"
        cmd = open("|#{@cmd} #{args}").close
      rescue Exception
        return false
      end
      return true
    end
  end

  class PdftkOSX < PDFTools::Template
    cmd  'pdftk2'
    args '__pdf_files__ output __target_pdf__'
    info 'Visit http://test.com'
  end

  class GhostscriptWin < PDFTools::Template
    cmd  'C:\Program Files\gs\gs9.06\bin\gs\gswin64c.exe'
    args ' -sDevice=pdfwrite __pdf_files__ -sOutputFile=__target_pdf__'
    info 'Visit me!'
  end

  class GhostscriptOSX < PDFTools::Template
  end

end