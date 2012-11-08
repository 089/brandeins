module BrandEinsHelper
  def windows?
    RUBY_PLATFORM.include? 'w32'
  end
end