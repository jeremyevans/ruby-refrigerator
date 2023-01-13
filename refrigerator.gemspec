spec = Gem::Specification.new do |s|
  s.name = 'refrigerator'
  s.version = '1.5.1'
  s.platform = Gem::Platform::RUBY
  s.extra_rdoc_files = ["README.rdoc", "CHANGELOG", "MIT-LICENSE"]
  s.rdoc_options += ["--quiet", "--line-numbers", "--inline-source", '--title', 'Refrigerator: Freeze all core ruby classes', '--main', 'README.rdoc']
  s.license = "MIT"
  s.summary = "Freeze all core ruby classes"
  s.author = "Jeremy Evans"
  s.email = "code@jeremyevans.net"
  s.homepage = "http://github.com/jeremyevans/ruby-refrigerator"
  s.files = %w(MIT-LICENSE CHANGELOG README.rdoc Rakefile bin/check_require) + Dir["{spec,lib}/**/*.rb"] + Dir['module_names/*.txt']
  s.required_ruby_version = ">= 1.8.7"
  s.bindir = 'bin'
  s.executables << 'check_require'
  s.description = <<END
Refrigerator freezes all core classes.  It is designed to be used
in production, to make sure that none of the core classes are
modified at runtime.  It can also be used to check libraries to
make sure that they don't make unexpected modifications/monkey patches
to core classes.
END
  s.metadata = {
    'bug_tracker_uri'   => 'https://github.com/jeremyevans/ruby-refrigerator/issues',
    'changelog_uri'     => 'https://github.com/jeremyevans/ruby-refrigerator/blob/master/CHANGELOG',
    'mailing_list_uri'  => 'https://github.com/jeremyevans/ruby-refrigerator/discussions',
    'source_code_uri'   => 'https://github.com/jeremyevans/ruby-refrigerator',
  }
  s.add_development_dependency('minitest')
  s.add_development_dependency "minitest-global_expectations"
end
