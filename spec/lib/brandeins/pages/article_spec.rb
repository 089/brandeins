# encoding: utf-8

require 'spec_helper'
require_lib 'brandeins/pages/article'

describe BrandEins::Pages::Article do
  let(:article) do
    html = load_fixture 'artikel-schauspieler-daenemark.html'
    BrandEins::Pages::Article.new(html)
  end

  describe '#pdf_url' do
    it 'returns an url to a pdf document' do
      article.stub(brandeins_url: 'http://www.brandeins.de')
      expect(article.pdf_url).to eq 'http://www.brandeins.de/uploads/tx_b4/008_b1_01_13_mikrooekonomie.pdf'
    end
  end

end

