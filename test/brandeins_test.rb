require File.expand_path('../../lib/brandeins' , __FILE__)
require 'minitest/autorun'
require 'fakefs/safe'

class TestBrandEinsDownload < MiniTest::Unit::TestCase
  def setup
    @base_url = 'http://www.brandeins.de'
    @dir      = 'bdl'
    # Es muss eine Moeglichkeit geben beim Testen zu verhindern, dass
    # die Existenz des Pfades geprueft wird.
    # testing im allgemeinen: http://holmwood.id.au/~lindsay/2008/04/26/hints-for-testing-your-evolving-ruby-scripts/
  end

  def test_tmp_directories_get_created
    FakeFS do
      bdl = BrandEins::Downloader.new @dir
      assert File.directory?(File.expand_path("./#{@dir}/tmp"))
    end
  end

  def test_magazine_url_scraping
    html = <<-EOF
      <div class="jahrgang jahrgang-2012 jahrgang-latest">
        <h4>2012</h4>
        <ul>
          <li><a href="magazin/nein-sagen.html" title="Zum Magazin brand eins Online 1 2012" onmouseover="switch_magazine(2012, 1)" onfocus="switch_magazine(2012, 1)"><img src="typo3temp/pics/b9d755e0d1.jpg" width="55" height="73" alt="Ausgabe 01/2012 SCHWERPUNKT NEIN SAGEN"></a> 1</li>
          <li><a href="magazin/markenkommunikation.html" title="Zum Magazin brand eins Online 2 2012" onmouseover="switch_magazine(2012, 2)" onfocus="switch_magazine(2012, 2)"><img src="typo3temp/pics/1dccfc2c74.jpg" width="55" height="73" alt="Ausgabe 02/2012 SCHWERPUNKT Markenkommunikation"></a> 2</li>
        </ul>
      </div>
    EOF

    archive_site = BrandEins::Downloader::ArchiveSite.new @base_url, html
    magazine_links = archive_site.get_magazine_links_by_year(2012)
    assert_equal magazine_links.length, 2
    assert_equal magazine_links[0], (@base_url + '/magazin/nein-sagen.html')
    assert_equal magazine_links[1], (@base_url + '/magazin/markenkommunikation.html')
  end
end
