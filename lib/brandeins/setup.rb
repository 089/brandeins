class BrandEinsSetup
  def initialize
    puts 'Checking requirements for your system'
    if pdftk?
      puts "\n" + 'It seems you have pdftk installed on your system.'
    else
      puts "\n" + 'It seems you are missing pdfk on your system. You are ready to go!'
      puts pdfk_install_instructions
    end
  end

  def pdfk_install_instructions
    'Visit http://www.pdflabs.com/docs/install-pdftk/ to install pdftk on your system'
  end

  def pdftk?
    if system(cmd).nil? then false else true end
  end
end