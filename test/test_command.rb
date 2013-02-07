# coding: utf-8

require 'helper'
# Intercept STDOUT and collect it
class Looper::Command

  def self.capture_output
    @output = ''
  end

  def self.captured_output
    @output
  end

  def self.output(s)
    @output << s
  end

  def self.save!
    # no-op
  end

end

class TestCommand < Test::Unit::TestCase
  def setup
    looper_json :urls
  end

  def command(cmd)
    cmd = cmd.split(' ') if cmd
    Looper::Command.capture_output
    Looper::Command.execute(*cmd)
    output = Looper::Command.captured_output
    output.gsub(/\e\[\d\d?m/, '')
  end

  def test_overview_for_empty
    storage = Looper::Storage
    storage.stubs(:lists).returns([])
    Looper::Command.stubs(:storage).returns(storage)
    assert_match /have anything yet!/, command(nil)
  end

  def test_overview
    assert_equal '  urls (2)', command(nil)
  end

  def test_help
    #assert_match 'looper help', command('help')
    assert_match 'looper help', command('-h')
    #assert_match 'looper help', command('--help')
  end

  #def test_noop_options
  #  assert_match 'looper help', command('--anything')
  #  assert_match 'looper help', command('-d')
  #end


end