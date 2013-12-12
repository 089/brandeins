require 'pathname'
# Access it like:
#   BrandEins::Config['base_uri']
#
module BrandEins
  class Config
    BASE_URI    = 'http://www.brandeins.de'
    ARCHIVE_URI = BASE_URI + '/archiv.html'
    BASE_PATH   = Pathname.new(ENV['HOME']) + '.brandeins'
    CACHE_PATH  = BASE_PATH + 'cache'
    TEMP_PATH   = BASE_PATH + 'temp'

    def self.[](name)
      const_get(name.upcase)
    end
  end
end
