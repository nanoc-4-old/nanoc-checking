# encoding: utf-8

class Nanoc::Checking::Checks::InternalLinksTest < Minitest::Test

  include TestHelper

  def test_run
    # Create files
    FileUtils.mkdir_p('output')
    FileUtils.mkdir_p('build/stuff')
    File.open('build/foo.txt',  'w') { |io| io.write('<a href="/broken">broken</a>') }
    File.write('build/bar.html', '<a href="/foo.txt">not broken</a>')

    # Create check
    check = Nanoc::Checking::Checks::InternalLinks.new(site_here)
    check.run

    # Test
    assert check.issues.empty?
  end

  def test_valid?
    # Create files
    FileUtils.mkdir_p('output')
    FileUtils.mkdir_p('build/stuff')
    File.open('build/origin',     'w') { |io| io.write('hi') }
    File.open('build/foo',        'w') { |io| io.write('hi') }
    File.write('build/stuff/blah', 'hi')

    # Create check
    check = Nanoc::Checking::Checks::InternalLinks.new(site_here)

    # Test
    assert check.send(:valid?, 'foo',         'build/origin')
    assert check.send(:valid?, 'origin',      'build/origin')
    assert check.send(:valid?, 'stuff/blah',  'build/origin')
    assert check.send(:valid?, '/foo',        'build/origin')
    assert check.send(:valid?, '/origin',     'build/origin')
    assert check.send(:valid?, '/stuff/blah', 'build/origin')
  end

  def test_remove_query_string
    FileUtils.mkdir_p('build/stuff')
    File.write('build/stuff/right', 'hi')

    check = Nanoc::Checking::Checks::InternalLinks.new(site_here)

    assert check.send(:valid?, 'stuff/right?foo=123', 'build/origin')
    refute check.send(:valid?, 'stuff/wrong?foo=123', 'build/origin')
  end

  def test_exclude
    # Create check
    config = { :checks => { :internal_links => { :exclude => ['^/excluded\d+'] } } }
    File.write('nanoc.yaml', YAML.dump(config))
    check = Nanoc::Checking::Checks::InternalLinks.new(site_here)

    # Test
    assert check.send(:valid?, '/excluded1', 'build/origin')
    assert check.send(:valid?, '/excluded2', 'build/origin')
    assert !check.send(:valid?, '/excluded_not', 'build/origin')
  end

  def test_unescape_url
    FileUtils.mkdir_p('build/stuff')
    File.write('build/stuff/right foo', 'hi')

    check = Nanoc::Checking::Checks::InternalLinks.new(site_here)

    assert check.send(:valid?, 'stuff/right%20foo', 'build/origin')
    refute check.send(:valid?, 'stuff/wrong%20foo', 'build/origin')
  end

end
