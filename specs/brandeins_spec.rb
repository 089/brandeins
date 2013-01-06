require 'minitest/spec'
require 'minitest/autorun'
require 'webmock/minitest'
require File.expand_path('../../lib/brandeins', __FILE__)

describe BrandEins do
  it "shows current version" do
    out = capture_stdout do
      BrandEins::CLI.start(['--version'])
    end
    assert_equal BrandEins::VERSION, out.string.chomp
  end

  it "runs pdftk" do
    response_archiv = IO.read(File.expand_path('../../test_support/fixtures/brandeins_archiv.html', __FILE__))
    jpgfile = IO.binread(File.expand_path('../../test_support/fixtures/cover.jpg', __FILE__))

    stub_request(:get, 'http://www.brandeins.de/archiv.html')
      .to_return(body: response_archiv, status: 200)

    stub_request(:get, %r{http:\/\/www\.brandeins\.de\/magazin\/(?:.*)})
      .to_return(body: '', status: 200)

    stub_request(:get, "http://www.brandeins.de/typo3temp/pics/e150dc2f8b.jpg")
      .to_return(body: jpgfile, status: 200)

    # cmd = "pdftk '/Users/gregoryigelmund/Workspace/ruby/gems/brandeins/brand-eins-tmp/cover-2012-1.pdf' output /Users/gregoryigelmund/Workspace/ruby/gems/brandeins/Brand-Eins-2012-1.pdf"
    # pdf_tool = MiniTest::Mock.new
    # pdf_tool.expect(:_exec, true, cmd)
    # pdf_tool.expect(:nil?, false)
    # BrandEins::PdfTools.define_singleton_method(:get_pdf_tool) do pdf_tool end

    out = capture_stdout do
      BrandEins::CLI.start(['download', '--year=2012', '--volume=1'])
    end

    assert_equal BrandEins::VERSION, out.string.chomp
  end
end