require File.expand_path '../setup.rb', __FILE__

class BrandEinsSetupWin < BrandEinsSetup
  def pdftk?
    _cmd? 'pdftk.exe --version', 'pdftk.com'
  end
end

BrandEinsSetupWin.new