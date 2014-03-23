# encoding: utf-8

require 'helper'

class Nanoc::Checking::CheckTest < Minitest::Test

  include TestHelper

  def test_build_filenames
    check = Nanoc::Checking::Check.new(Nanoc::SiteLoader.new.load)
    assert check.build_filenames.empty?
    File.open('build/foo.html', 'w') { |io| io.write 'hello' }
    assert_equal [ 'build/foo.html' ], check.build_filenames
  end

end
