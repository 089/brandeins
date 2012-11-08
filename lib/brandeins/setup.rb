class BrandEinsSetup
  def initialize
    p 'Checking requirements for your system'
    if pdftk?
      p 'It seems you have pdftk installed on your system.'
    else
      p 'It seems you are missing pdfk on your system.'
      p pdfk_install_instructions
    end
  end

  def pdfk_install_instructions
    'Visit http://www.pdflabs.com/docs/install-pdftk/ to install pdftk on your system'
  end

  def pdftk?
    cmd? 'pdftk --version', 'pdftk.com'
  end

  private
  def cmd?(cmd, hint)
    f = IO.popen cmd
    f.readlines.each do |line|
      if line.include? hint
        return true
      end
    end
    return false
  end
end

BrandEinsSetup.new