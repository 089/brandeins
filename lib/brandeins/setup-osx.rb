require File.expand_path '../setup.rb', __FILE__

class BrandEinsSetupOSX < BrandEinsSetup
  def pdftk?
    _cmd? 'pdftk --version', 'pdftk.com'
  end
end

BrandEinsSetupOSX.new