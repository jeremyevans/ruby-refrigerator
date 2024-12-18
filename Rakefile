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

RDOC_DEFAULT_OPTS = ["--quiet", "--line-numbers", "--inline-source", '--title', 'Refrigerator: Freeze core ruby classes']

begin
  gem 'rdoc'
  gem 'hanna'
  RDOC_DEFAULT_OPTS.concat(['-f', 'hanna'])
rescue Gem::LoadError
end

rdoc_task_class = begin
  require "rdoc/task"
  RDoc::Task
rescue LoadError
  require "rake/rdoctask"
  Rake::RDocTask
end

RDOC_OPTS = RDOC_DEFAULT_OPTS + ['--main', 'README.rdoc']

rdoc_task_class.new do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.options += RDOC_OPTS
  rdoc.rdoc_files.add %w"README.rdoc CHANGELOG MIT-LICENSE lib/**/*.rb"
end
