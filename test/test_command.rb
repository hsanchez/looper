# coding: utf-8

require 'helper'
# Intercept STDOUT and capture its output
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

  C_DIR      =  "#{File.expand_path(File.dirname(__FILE__))}/examples"

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
    assert_match 'looper help', command('help')
    assert_match 'looper help', command('-h')
    assert_match 'looper help', command('--help')
  end

  def test_noop_options
    assert_match 'looper help', command('--anything')
    assert_match 'looper help', command('-d')
  end

  def test_edit
    Looper::Platform.stubs(:system).returns('')
    assert_match 'Make your edits', command('edit')
  end

  def test_project_all
    cmd = command('all')
    assert_match /urls/,    cmd
    assert_match /huascar/,  cmd
  end

  def test_version_short
    assert_match /#{Looper::VERSION}/, command('-v')
  end

  def test_version_long
    assert_match /#{Looper::VERSION}/, command('--version')
  end

  def test_delete_item_project_not_exist
    assert_match /couldn't find that project\./, command('urlz huascar delete')
  end

  def test_show_storage
    Looper::Config.any_instance.stubs(:attributes).returns('backend' => 'json')
    assert_match /You're currently using json/, command('storage')
  end

  def test_project_creation
    assert_match /a new project called newproject/, command('newproject')
  end

  def test_project_assigns_source
    assert_match /a new project called newproject.* src in newproject/, command('newproject src blah/blah')
  end

  def test_project_peek_nothing_to_report
    command("newproject src #{C_DIR}")
    assert_match /couldn't find anything to report for newproject.*/, command('newproject peek')
  end

end