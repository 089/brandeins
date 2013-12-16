# encoding: utf-8

require_relative '../../spec_helper'

require_lib 'brandeins'
require_lib 'brandeins/config'
require_lib 'brandeins/kiosk'

require 'tempfile'
require 'pathname'

describe BrandEins::Kiosk do
  describe '#initialize(options)' do
    it 'takes :path from options' do
      path = Tempfile.new('test').path
      kiosk = BrandEins::Kiosk.new(path: path)
      expect(kiosk.target_path).to eq path
    end

    it 'defauls to the current working directory if no path is given' do
      kiosk = BrandEins::Kiosk.new
      cwd = Pathname.new('.').realpath.to_s
      expect(kiosk.target_path).to eq cwd
    end

    it 'raises InvalidPathError if the given path is not accessible' do
      invalid_path = '/root'
      expect {
        BrandEins::Kiosk.new(path: invalid_path)
      }.to raise_error BrandEins::Kiosk::InvalidPathError
    end
  end

  describe '#fetch_magazine(month: 1, year: 2013)' do
    it 'returns a magzine object' do
      archive_html = load_fixture 'archive.html'
      stub_request(:get, BrandEins::Config['archive_uri']).
        to_return(body: archive_html)

      magazine_html = load_fixture 'magazine-1-2013.html'
      stub_request(:get, 'http://www.brandeins.de/archiv/2013/neugier.html').
        to_return(status: 200, body: magazine_html)

      article_masskonfektion_html = load_fixture 'artikel-masskonfektion-aus-plastik.html'
      stub_request(:get, 'http://www.brandeins.de/archiv/2013/neugier/masskonfektion-aus-plastik.html').
        to_return(status: 200, body: article_masskonfektion_html)

      article_daenemark_html = load_fixture 'artikel-schauspieler-daenemark.html'
      stub_request(:get, 'http://www.brandeins.de/archiv/2013/neugier/ein-schauspieler-in-daenemark.html').
        to_return(status: 200, body: article_daenemark_html)

      pdf_file = load_fixture 'just-a.pdf'
      stub_request(:get, "http://www.brandeins.de/uploads/tx_b4/030_b1_01_13_prototypen.pdf").
        to_return(body: pdf_file)
      stub_request(:get, "http://www.brandeins.de/uploads/tx_b4/008_b1_01_13_mikrooekonomie.pdf").
        to_return(body: pdf_file)
      stub_request(:get, "http://www.brandeins.de/typo3temp/pics/titel_0113_77be1ece47.jpg").
        to_return(status: 400, body: "")


      kiosk = BrandEins::Kiosk.new
      magazine = kiosk.fetch_magazine(month: 1, year: 2013)
      expect(magazine).to be_a BrandEins::Pages::Magazine
    end
  end
end
