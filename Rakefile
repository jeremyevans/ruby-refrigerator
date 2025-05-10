require "rake"
require "rake/clean"

CLEAN.include ["refrigerator-*.gem", "rdoc", "coverage"]

desc "Build refrigerator gem"
task :package=>[:clean] do |p|
  sh %{#{FileUtils::RUBY} -S gem build refrigerator.gemspec}
end

### Generate module_names

desc "Generate module_names/*.txt file for current ruby version"
task :module_names do
  sh "#{FileUtils::RUBY} gen_module_names.rb"
end


### Specs

desc "Run specs"
task :spec do
  sh "#{FileUtils::RUBY} #{"-w" if RUBY_VERSION >= '3'} #{'-W:strict_unused_block' if RUBY_VERSION >= '3.4'} test/refrigerator_test.rb"
end

task :default => :spec

desc "Run tests with coverage"
task :spec_cov do
  ENV['COVERAGE'] = '1'
  sh "#{FileUtils::RUBY} test/refrigerator_test.rb"
end

### RDoc

desc "Generate rdoc"
task :rdoc do
  rdoc_dir = "rdoc"
  rdoc_opts = ["--line-numbers", "--inline-source", '--title', 'Refrigerator: Freeze core ruby classes']

  begin
    gem 'hanna'
    rdoc_opts.concat(['-f', 'hanna'])
  rescue Gem::LoadError
  end

  rdoc_opts.concat(['--main', 'README.rdoc', "-o", rdoc_dir] +
    %w"README.rdoc CHANGELOG MIT-LICENSE" +
    Dir["lib/**/*.rb"]
  )

  FileUtils.rm_rf(rdoc_dir)

  require "rdoc"
  RDoc::RDoc.new.document(rdoc_opts)
end
