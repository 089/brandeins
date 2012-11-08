class BrandEinsSetup
  def initialize
    puts 'Checking requirements for your system'
    if pdftk?
      puts 'It seems you have pdftk installed on your system.'
    else
      puts 'It seems you are missing pdfk on your system. You are ready to go!'
      puts pdfk_install_instructions
    end
  end

  def pdfk_install_instructions
    'Visit http://www.pdflabs.com/docs/install-pdftk/ to install pdftk on your system'
  end

  def pdftk?
    raise 'Missing implementation'
  end

  protected
  def _cmd?(cmd, hint)
    if RUBY_PLATFORM.include? 'darwin'
      _cmdosx(cmd, hint)
    elsif RUBY_PLATFORM.include? 'w32'
      _cmdw32(cmd, hint)
    end
  end

  def _cmdw32(cmd, hint)
    f = IO.popen cmd
    f.readlines.each do |line|
      if line.include? hint
        return true
      end
    end
  end

  def _cmdosx(cmd, hint)
    f = IO.popen cmd
    f.readlines.each do |line|
      if line.include? hint
        return true
      end
    end
  end
end