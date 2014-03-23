# encoding: utf-8

class Nanoc::Checking::Checks::ExternalLinksTest < Minitest::Test

  include TestHelper

  def test_run
    # Create files
    FileUtils.mkdir_p('output')
    File.open('build/foo.txt',  'w') { |io| io.write('<a href="http://example.com/404">broken</a>') }
    File.write('build/bar.html', '<a href="http://example.com/">not broken</a>')

    # Create check
    check = Nanoc::Checking::Checks::ExternalLinks.new(site_here)
    def check.request_url_once(url)
      Net::HTTPResponse.new('1.1', url.path == '/' ? '200' : '404', 'okay')
    end
    check.run

    # Test
    assert check.issues.empty?
  end

  def test_valid_by_path
    # Create check
    check = Nanoc::Checking::Checks::ExternalLinks.new(site_here)
    def check.request_url_once(url)
      Net::HTTPResponse.new('1.1', url.path == '/200' ? '200' : '404', 'okay')
    end

    # Test
    assert_nil check.validate('http://127.0.0.1:9204/200')
    assert_nil check.validate('foo://example.com/')
    refute_nil check.validate('http://127.0.0.1:9204">')
  end

  def test_valid_by_query
    # Create check
    check = Nanoc::Checking::Checks::ExternalLinks.new(site_here)
    def check.request_url_once(url)
      Net::HTTPResponse.new('1.1', url.query == 'status=200' ? '200' : '404', 'okay')
    end

    # Test
    assert_nil check.validate('http://example.com/?status=200')
    refute_nil check.validate('http://example.com/?status=404')
  end

  def test_fallback_to_get_when_head_is_not_allowed
    # Create check
    check = Nanoc::Checking::Checks::ExternalLinks.new(site_here)
    def check.request_url_once(url, req_method = Net::HTTP::Head)
      Net::HTTPResponse.new('1.1', (req_method == Net::HTTP::Head || url.path == '/405') ? '405' : '200', 'okay')
    end

    # Test
    assert_nil check.validate('http://127.0.0.1:9204')
    refute_nil check.validate('http://127.0.0.1:9204/405')
  end

  def test_path_for_url
    check = Nanoc::Checking::Checks::ExternalLinks.new(site_here)

    assert_equal '/',             check.send(:path_for_url, URI.parse('http://example.com'))
    assert_equal '/',             check.send(:path_for_url, URI.parse('http://example.com/'))
    assert_equal '/?foo=bar',     check.send(:path_for_url, URI.parse('http://example.com?foo=bar'))
    assert_equal '/?foo=bar',     check.send(:path_for_url, URI.parse('http://example.com/?foo=bar'))
    assert_equal '/meow?foo=bar', check.send(:path_for_url, URI.parse('http://example.com/meow?foo=bar'))
  end

  def test_resolve_redirect
    check = Nanoc::Checking::Checks::ExternalLinks.new(site_here)

    assert_equal 'http://example.com/bar',
      check.resolve_redirect(URI.parse('http://example.com/foo'), 'http://example.com/bar')
  end

  def test_resolve_hostless_redirect
    check = Nanoc::Checking::Checks::ExternalLinks.new(site_here)

    assert_equal 'http://example.com/bar',
      check.resolve_redirect(URI.parse('http://example.com/foo'), '/bar')
  end

end
