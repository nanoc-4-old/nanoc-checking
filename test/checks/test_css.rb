# encoding: utf-8

class Nanoc::Checking::Checks::CSSTest < Minitest::Test

  include TestHelper

  def test_run_ok
    # Create files
    File.write('build/blah.html', '<h1>Hi!</h1>')
    File.write('build/style.css', 'h1 { color: red; }')

    # Run check
    check = Nanoc::Checking::Checks::CSS.new(site_here)
    check.run

    # Check
    assert check.issues.empty?
  end

  def test_run_error
    # Create files
    File.write('build/blah.html', '<h1>Hi!</h1>')
    File.write('build/style.css', 'h1 { coxlor: rxed; }')

    # Run check
    check = Nanoc::Checking::Checks::CSS.new(site_here)
    check.run

    # Check
    refute check.issues.empty?
  end

end

