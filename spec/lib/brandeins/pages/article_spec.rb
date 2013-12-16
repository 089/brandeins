# encoding: utf-8

require_relative '../../../spec_helper'

require_lib 'brandeins/pages/article'

describe BrandEins::Pages::Article do
  let(:article) { BrandEins::Pages::Article.new(load_fixture 'artikel-schauspieler-daenemark.html') }

  describe '#pdf_url' do
    it 'returns an url to a pdf document' do
      expect(article.pdf_url).to eq 'http://www.brandeins.de/uploads/tx_b4/008_b1_01_13_mikrooekonomie.pdf'
    end
  end

  describe '#title' do
    it 'parses the title of the article' do
      expect(article.title).to eq 'Ein Schauspieler in Dänemark'
    end
  end

end

