# encoding: utf-8

require 'helper'

class Nanoc::Checking::CheckTest < Minitest::Test

  include TestHelper

  def test_output_filenames
    check = Nanoc::Checking::Check.new(Nanoc::SiteLoader.new.load)
    assert check.output_filenames.empty?
    File.open('output/foo.html', 'w') { |io| io.write 'hello' }
    assert_equal [ 'output/foo.html' ], check.output_filenames
  end

end
