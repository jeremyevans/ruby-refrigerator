# Refrigerator allows for easily freezing core classes and modules.
module Refrigerator
  version_int = RUBY_VERSION[0..2].sub('.', '').to_i
  version_int = 25 if version_int > 25
  
  # Array of strings containing class or module names.
  CORE_MODULES = File.read(File.expand_path(File.join(File.expand_path(__FILE__), "../../module_names/#{version_int}.txt"))).
    split(/\s+/).
    select{|m| eval("defined?(#{m})")}.
    each(&:freeze).
    freeze

  # Default frozen options hash
  OPTS = {}.freeze

  # Freeze core classes and modules.  Options:
  # :except :: Don't freeze any of the classes modules listed (array of strings)
  def self.freeze_core(opts=OPTS)
    (CORE_MODULES - Array(opts[:except])).each{|m| eval(m).freeze}
    nil
  end

  # Check that requiring a given file does not modify any core classes. Options:
  # :depends :: Require the given files before freezing the core (array of strings)
  # :modules :: Define the given modules in the Object namespace before freezing the core (array of module name symbols)
  # :classes :: Define the given classes in the Object namespace before freezing the core (array of either class name Symbols or
  #             array with class Name Symbol and Superclass name string)
  # :except :: Don't freeze any of the classes modules listed (array of strings)
  def self.check_require(file, opts=OPTS)
    require 'rubygems'
    Array(opts[:depends]).each{|f| require f}
    Array(opts[:modules]).each{|m| Object.const_set(m, Module.new)}
    Array(opts[:classes]).each{|c, *sc| Object.const_set(c, Class.new(sc.empty? ? Object : eval(sc.first.to_s)))}
    freeze_core(:except=>%w'Gem Gem::Specification'+Array(opts[:exclude]))
    require file
  end

  freeze
end
