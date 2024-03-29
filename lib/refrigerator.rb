# Refrigerator allows for easily freezing core classes and modules.
module Refrigerator
  version_int = RUBY_VERSION[0..2].sub('.', '').to_i
  filepath = lambda do
    File.expand_path(File.join(File.expand_path(__FILE__), "../../module_names/#{version_int}.txt"))
  end
  if version_int >= 18
    # :nocov:
    version_int -= 1 until File.file?(filepath.call)
    # :nocov:
  end
  
  # Array of strings containing class or module names.
  CORE_MODULES = File.read(filepath.call).
    split(/\s+/).
    select{|m| eval("defined?(#{m})", nil, __FILE__, __LINE__)}.
    each(&:freeze).
    reverse.
    freeze

  # Default frozen options hash
  OPTS = {}.freeze

  # Freeze core classes and modules.  Options:
  # :except :: Don't freeze any of the classes modules listed (array of strings)
  def self.freeze_core(opts=OPTS)
    (CORE_MODULES - Array(opts[:except])).each{|m| eval(m, nil, __FILE__, __LINE__).freeze}
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
    Array(opts[:classes]).each{|c, *sc| Object.const_set(c, Class.new(sc.empty? ? Object : eval(sc.first.to_s, nil, __FILE__, __LINE__)))}
    freeze_core(:except=>%w'Gem Gem::Specification Gem::Deprecate'+Array(opts[:exclude]))
    require file
  end

  freeze
end
