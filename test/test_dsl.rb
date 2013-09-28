# encoding: utf-8

require 'helper'

class Nanoc::Checking::DSLTest < Minitest::Test

  include TestHelper

  def test_from_file
    File.write('Checks', "check :foo do\n\nend\ndeploy_check :bar\n")
    dsl = Nanoc::Checking::DSL.from_file('Checks')

    # One new check
    refute Nanoc::Checking::Check.named(:foo).nil?

    # One check marked for deployment
    assert_equal [ :bar ], dsl.deploy_checks
  end

end
