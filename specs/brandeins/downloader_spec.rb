require 'minitest/spec'
require 'minitest/autorun'
require 'webmock/minitest'
require 'fakefs/safe'

# require_relative '../../lib/brandeins/downloader'

describe BrandEins::Downloader do

  let(:opts) do
    { path: '/some/fake/path',
      base_url: 'http://example.com',
      archive_url: 'http://example.com/archive.html'
    }
  end

  it "ignores unavailable downloads" do
    stub_request(:get, opts[:archive_url]).
      to_return(status: 200, body: '')
    FakeFS do
      downloader = BrandEins::Downloader.new(opts[:path], opts)
      downloader.get_magazine(1966, 1)
    end
  end

end
