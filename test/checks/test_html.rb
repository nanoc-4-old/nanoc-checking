# encoding: utf-8

class Nanoc::Checking::Checks::HTMLTest < Minitest::Test

  include TestHelper

  def test_run_ok
    # Create files
    FileUtils.mkdir_p('output')
    File.write('build/blah.html', '<!DOCTYPE html><html><head><meta charset="utf-8"><title>Hello</title></head><body><h1>Hi!</h1></body>')
    File.write('build/style.css', 'h1 { coxlor: rxed; }')

    # Run check
    check = Nanoc::Checking::Checks::HTML.new(site_here)
    check.run

    # Check
    assert check.issues.empty?
  end

  def test_run_error
    # Create files
    FileUtils.mkdir_p('output')
    File.write('build/blah.html', '<h2>Hi!</h1>')
    File.write('build/style.css', 'h1 { coxlor: rxed; }')

    # Run check
    check = Nanoc::Checking::Checks::HTML.new(site_here)
    check.run

    # Check
    refute check.issues.empty?
  end

end

