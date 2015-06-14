# encoding: utf-8

require 'pathname'

module BrandEins
  # Used to store and retrieve default settings
  # Access it like:
  #   BrandEins::Config['base_uri']
  class Config
    BASE_URI          = 'http://www.brandeins.de'
    ARCHIVE_URI       = BASE_URI + '/archiv/'
    BASE_PATH         = Pathname.new(ENV['HOME']) + '.brandeins'
    CACHE_PATH        = BASE_PATH + 'cache'
    TEMP_PATH         = BASE_PATH + 'temp'
    CACHE_LIMIT_BYTES = 400 * 1024**2

    def self.[](name)
      const_get(name.upcase)
    end
  end
end
