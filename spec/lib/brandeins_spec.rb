# encoding: utf-8

require_relative '../spec_helper'

require_lib 'brandeins'
require_lib 'brandeins/cli'

describe BrandEins do

  describe '.run' do
    it 'shows current version' do
      version = capture_stdout do
        BrandEins::Cli.run(%w[version])
      end.chomp
      expect(version).to eq BrandEins::VERSION
    end
  end

end
