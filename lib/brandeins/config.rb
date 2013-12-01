# Access it like:
#   BrandEins::Config['base_uri']
#
module BrandEins
  class Config
    BASE_URI    = 'http://www.brandeins.de'
    ARCHIVE_URI = BASE_URI + '/archive.html'

    def self.[](name)
      const_get(name.upcase)
    end
  end
end
