# encoding: utf-8

require_relative "../../../spec_helper"

require_lib "brandeins/pages/magazine"

describe BrandEins::Pages::Magazine do
  let(:html) { load_fixture "magazine-1-2013.html" }
  let(:page) { BrandEins::Pages::Magazine.new(html) }

  describe "#initialize" do
    it "takes html to parse" do
      expect(page.html).to eq html
    end

    it "can take an url and loads the html" do
      stub_request(:get, "http://www.brandeins.de/magazine.html").
        to_return(status: 200, body: html)
      page = BrandEins::Pages::Magazine.new(url: "http://www.brandeins.de/magazine.html")
      expect(page.html).to eq html
    end
  end

  describe "#article_urls" do
    it "returns an array of urls to article pages" do
      expect(page.article_urls.first).to eq "http://www.brandeins.de/archiv/2013/neugier/weiter/"
      expect(page.article_urls.last).to  eq "http://www.brandeins.de/archiv/2013/neugier/wer-hats-gesagt/"
      expect(page.article_urls.size).to  eq 31
    end
  end

  describe "#article_pdf_urls" do
    it "returns an array of urls to pdf files of articles" do
      article_weiter_html    = load_fixture "artikel-masskonfektion-aus-plastik.html"
      article_daenemark_html = load_fixture "artikel-schauspieler-daenemark.html"

      stub_request(:get, "http://www.brandeins.de/archiv/2013/neugier/masskonfektion-aus-plastik.html").
        to_return(status: 200, body: article_weiter_html)
      stub_request(:get, "http://www.brandeins.de/archiv/2013/neugier/ein-schauspieler-in-daenemark.html").
        to_return(status: 200, body: article_daenemark_html)

      expect(page.article_pdf_urls.size).to  eq 2
      expect(page.article_pdf_urls.first).to eq "http://www.brandeins.de/uploads/tx_b4/030_b1_01_13_prototypen.pdf"
      expect(page.article_pdf_urls.last).to  eq "http://www.brandeins.de/uploads/tx_b4/008_b1_01_13_mikrooekonomie.pdf"
    end
  end

  describe "#cover_url" do
    it "returns the cover image url if existent" do
      html_cover = load_fixture "magazine-with-cover.html"
      page_cover = BrandEins::Pages::Magazine.new(html)
      expect(page_cover.cover_url).to eq "http://www.brandeins.de/typo3temp/pics/titel_0113_77be1ece47.jpg"
    end

    it "returns the fallback cover image" do
      html_cover_fallback = load_fixture "magazine-cover-fallback.html"
      page_cover_fallback = BrandEins::Pages::Magazine.new(html_cover_fallback)
      expect(page_cover_fallback.cover_url).to eq "http://www.brandeins.de/uploads/tx_b4/05v2.png"
    end

    it "returns nil if no cover image or fallback is given" do
      page = BrandEins::Pages::Magazine.new ""
      expect(page.cover_url).to eq nil
    end
  end

  describe "#title" do
    it "returns the current issues title" do
      expect(page.title).to eq "Neugier"
    end
  end

  describe "#year" do
    it "returns the correct year (2013)" do
      expect(page.year).to eq 2013
    end
  end

  describe "#month" do
    it "returns the correct month (1)" do
      expect(page.month).to eq 1
    end
  end

  describe "#url" do
    it "returns the correct url" do
      expect(page.url).to eq "http://www.brandeins.de/archiv/2013/neugier/"
    end
  end

end
