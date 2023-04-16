if RUBY_VERSION > '2.4'
  require 'warning'
  # Turn warnings into errors so refrigerator will not attempt to freeze modules
  # when referencing the module issues a warning.
  Warning.process('', // => :raise)
  $VERBOSE = true
  if RUBY_VERSION > '2.7'
    Warning[:deprecated] = true
  end
end

a = []
ObjectSpace.each_object(Module) do |m|
  m = m.name.to_s
  next unless !m.empty? && eval("defined?(#{m})")
  case m
  when 'Warning::Processor'
    # Specific to warning gem loaded in this script, not part of core ruby
    next
  when 'Gem::BundlerVersionFinder'
    # Work around JRuby 9.3 bug
    next if RUBY_VERSION.start_with?('2.6')
  end

  begin
    eval(m)
  rescue RuntimeError
    # skip if referencing constant raises error or warning
  else
    a << m
  end
end

File.open("module_names/#{RUBY_VERSION[0..2].sub('.', '')}.txt", "wb") do |f|
  f.write(a.sort.join("\n"))
  f.write("\n")
end
