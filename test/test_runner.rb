# encoding: utf-8

require 'helper'

class Nanoc::Checking::RunnerTest < Minitest::Test

  include TestHelper

  def test_run_specific
    File.write('build/blah', 'I am stale! Haha!')
    runner = Nanoc::Checking::Runner.new(Nanoc::SiteLoader.new.load)
    capturing_stdio do
      runner.run_specific(%w( stale ))
    end
  end

  def test_run_specific_custom
    File.open('Checks', 'w') do |io|
      io.write('check :my_foo_check do ; puts "I AM FOO!" ; end')
    end

    runner = Nanoc::Checking::Runner.new(Nanoc::SiteLoader.new.load)
    ios = capturing_stdio do
      runner.run_specific(%w( my_foo_check ))
    end

    assert ios[:stdout].include?('I AM FOO!')
  end

  def test_list_checks
    File.open('Checks', 'w') do |io|
      io.write('check :my_foo_check do ; end')
    end

    runner = Nanoc::Checking::Runner.new(Nanoc::SiteLoader.new.load)
    ios = capturing_stdio do
      runner.list_checks
    end

    assert ios[:stdout].include?('my_foo_check')
    assert ios[:stdout].include?('internal_links')
    assert ios[:stderr].empty?
  end

end
