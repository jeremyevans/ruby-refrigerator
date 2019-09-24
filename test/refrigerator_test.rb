ENV['MT_NO_PLUGINS'] = '1' # Work around stupid autoloading of plugins
require 'rubygems'
gem 'minitest'
require 'minitest/global_expectations/autorun'

RUBY = ENV["RUBY"] || File.join(
  RbConfig::CONFIG["bindir"],
  RbConfig::CONFIG["ruby_install_name"] + RbConfig::CONFIG["EXEEXT"]).
  sub(/.*\s.*/m, '"\&"')
REFRIGERATOR = File.join(File.dirname(File.expand_path(__FILE__)), '../lib/refrigerator')
EXAMPLE = File.join(File.dirname(File.expand_path(__FILE__)), '../test/example')

describe "Refrigerator" do
  def check(code)
    system(RUBY, '-r', REFRIGERATOR, '-e', code).must_equal true
  end

  it '.freeze_core should freeze all core classes' do
    check(<<-END)
      Refrigerator.freeze_core
      raise unless Object.frozen?
      raise unless String.frozen?
      raise unless Array.frozen?
      raise unless Hash.frozen?
      raise unless Symbol.frozen?
    END
  end

  it '.freeze_core should have :except option not freeze core classes' do
    check(<<-END)
      Refrigerator.freeze_core(:except=>%w'Object Hash')
      raise if Object.frozen?
      raise unless String.frozen?
      raise unless Array.frozen?
      raise if Hash.frozen?
      raise unless Symbol.frozen?
    END
  end

  it '.check_require should fail for ostruct' do
    check(<<-END)
      begin
        Refrigerator.check_require 'ostruct'
      rescue
      else
        exit 1
      end
    END
  end

  it '.check_require should pass for open3' do
    check(<<-END)
      Refrigerator.check_require('open3', :modules=>[:Open3])
    END
  end

  it '.check_require should support :modules, :classes, :depends, and :exclude options' do
    check("raise unless (Refrigerator.check_require(#{EXAMPLE.inspect}) rescue :foo) == :foo")
    check("raise unless (Refrigerator.check_require(#{EXAMPLE.inspect}, :depends=>%w'set') rescue :foo) == :foo")
    check("raise unless (Refrigerator.check_require(#{EXAMPLE.inspect}, :depends=>%w'set', :modules=>[:A]) rescue :foo) == :foo")
    check("raise unless (Refrigerator.check_require(#{EXAMPLE.inspect}, :depends=>%w'set', :modules=>[:A], :classes=>[:B]) rescue :foo) == :foo")
    check("Refrigerator.check_require(#{EXAMPLE.inspect}, :depends=>%w'set', :modules=>[:A], :classes=>[:B, [:C, :B]])")
    check("Refrigerator.check_require(#{EXAMPLE.inspect}, :exclude=>%w'Object Enumerable')")
  end
end
