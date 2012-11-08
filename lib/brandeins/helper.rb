module BrandEinsHelper
  def self.windows?
    RUBY_PLATFORM.include? 'w32'
  end

  def self.osx?
    RUBY_PLATFORM.include? 'darwin'
  end
end