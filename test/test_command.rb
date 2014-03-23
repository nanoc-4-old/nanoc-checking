# encoding: utf-8

require 'helper'

class Nanoc::Checking::CommandTest < Minitest::Test

  include TestHelper

  def test_check_stale
    # Should not raise now
    capturing_stdio do
      Nanoc::CLI.run %w( check stale )
    end

    # Should raise now
    File.open('build/blah.html', 'w') { |io| io.write 'moo' }
    capturing_stdio do
      assert_raises Nanoc::Errors::GenericTrivial do
        Nanoc::CLI.run %w( check stale )
      end
    end
  end

end
