require 'spec_helper'
require_lib 'brandeins/pages/archive'

describe BrandEins::Pages::Archive do

  describe 'magazine_for(month: 1, year: 2000)' do
    it 'returns the magazine for a given month and year' do
      archive_html = load_fixture 'archive.html'
      archive = BrandEins::Pages::Archive.new(html: archive_html)

      magazine_html = load_fixture 'magazine-1-2013.html'
      stub_request(:get, 'http://www.brandeins.de/archiv/2013/neugier.html').
        to_return(status: 200, body: magazine_html)

      article_masskonfektion_html = load_fixture 'artikel-masskonfektion-aus-plastik.html'
      stub_request(:get, 'http://www.brandeins.de/archiv/2013/neugier/masskonfektion-aus-plastik.html').
        to_return(status: 200, body: article_masskonfektion_html)

      article_daenemark_html = load_fixture 'artikel-schauspieler-daenemark.html'
      stub_request(:get, 'http://www.brandeins.de/archiv/2013/neugier/ein-schauspieler-in-daenemark.html').
        to_return(status: 200, body: article_daenemark_html)

      magazine = archive.magazine_for(month: 1, year: 2013)

      expect(magazine.url).to              eq 'http://www.brandeins.de/archiv/2013/neugier.html'
      expect(magazine.title).to            eq 'Neugier'
      expect(magazine.year).to             eq 2013
      expect(magazine.month).to            eq 1
      expect(magazine.cover_url).to        eq 'http://www.brandeins.de/typo3temp/pics/titel_0113_77be1ece47.jpg'
      expect(magazine.article_pdf_urls).to eq [
        'http://www.brandeins.de/uploads/tx_b4/030_b1_01_13_prototypen.pdf',
        'http://www.brandeins.de/uploads/tx_b4/008_b1_01_13_mikrooekonomie.pdf'
      ]
    end
  end

end
