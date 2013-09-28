# encoding: utf-8

class Nanoc::Checking::Checks::StaleTest < Minitest::Test

  include TestHelper

  def check_class
    Nanoc::Checking::Checks::Stale
  end

  def calc_issues
    site = site_here
    compiler = Nanoc::Compiler.new(site)
    compiler.load
    check = check_class.new(site)
    check.run
    check.issues
  end

  def test_run_ok
    assert Dir['content/*'].empty?
    assert Dir['output/*'].empty?

    # Empty
    FileUtils.mkdir_p('output')
    assert self.calc_issues.empty?

    # One OK file
    File.write('content/index.html', 'stuff')
    File.write('output/index.html', 'stuff')
    assert self.calc_issues.empty?
  end

  def test_run_error
    assert Dir['content/*'].empty?
    assert Dir['output/*'].empty?

    File.write('content/index.html', 'stuff')
    File.write('output/WRONG.html', 'stuff')
    assert_equal 1, self.calc_issues.count
    issue = self.calc_issues.to_a[0]
    assert_equal "file without matching item", issue.description
    assert_equal "output/WRONG.html", issue.subject
  end

  def test_run_excluded
    assert Dir['content/*'].empty?
    assert Dir['output/*'].empty?

    File.open('nanoc.yaml', 'w') { |io| io.write "prune:\n  exclude: [ 'excluded.html' ]" }
    File.write('content/index.html', 'stuff')
    File.write('output/excluded.html', 'stuff')
    assert self.calc_issues.empty?
  end

  def test_run_excluded_with_broken_config
    assert Dir['content/*'].empty?
    assert Dir['output/*'].empty?

    File.open('nanoc.yaml', 'w') { |io| io.write "prune:\n  blah: meh" }
    File.write('content/index.html', 'stuff')
    File.write('output/excluded.html', 'stuff')
    refute self.calc_issues.empty?
  end

end
