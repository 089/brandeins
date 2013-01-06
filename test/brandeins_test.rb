require File.expand_path('../helper' , __FILE__)
require File.expand_path('../../lib/brandeins' , __FILE__)
require 'minitest/autorun'
# require 'fakefs/safe'

class TestBrandEinsDownload < MiniTest::Unit::TestCase
  def setup
    @base_url = 'http://www.brandeins.de'
    @dir      = 'bdl'
    # Es muss eine Moeglichkeit geben beim Testen zu verhindern, dass
    # die Existenz des Pfades geprueft wird.
    # testing im allgemeinen: http://holmwood.id.au/~lindsay/2008/04/26/hints-for-testing-your-evolving-ruby-scripts/
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

  def test_get_magazine_cover
    html =<<-EOF
    <li class="month_detail" id="month_detail_2012_4">
      <dl>
        <dt class="ausgabe">Ausgabe 4/2012</dt>
        <dt class="titel">SCHWERPUNKT Kapitalismus</dt>
        <dd class="cover">
          <a href="magazin/kapitalismus.html" title="Zum Magazin brand eins Online 4 2012">
            <img src="typo3temp/pics/08ff826417.jpg" width="235" height="311" alt="Ausgabe 04/2012 SCHWERPUNKT Kapitalismus"></a>
        </dd>
      </dl>
    </li>
    EOF

    archive_site = BrandEins::Downloader::ArchiveSite.new @base_url, html
    cover = archive_site.get_magazine_cover(2012, 4)
    assert_equal cover, { :title => "SCHWERPUNKT Kapitalismus", :img_url => "#{@base_url}/typo3temp/pics/08ff826417.jpg" }
  end

  def test_brandeins_setup_output
    pdf_tool = Object.new
    pdf_tool.define_singleton_method :available? do true end
    pdf_tool.define_singleton_method :cmd do 'magic' end

    setup = BrandEins::Setup.new :os => 'x86_64-darwin12.2.0', :pdf_tool => pdf_tool
    out = capture_stdout do
      setup.run
    end

    assert_equal "Checking requirements for your system\n\nIt seems you have magic running on your system. You are ready to go!\n", out.string
  end

end
