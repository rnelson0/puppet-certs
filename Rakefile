require 'rubygems'
require 'bundler/setup'

require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet/version'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'
require 'metadata-json-lint/rake_task'
require 'parallel_tests'
require 'parallel_tests/cli'
require 'github_changelog_generator/task'

# These gems aren't always present, for instance
# on Travis with --without development
begin
  require 'puppet_blacksmith/rake_tasks'
rescue LoadError
end

exclude_paths = [
  "bundle/**/*",
  "pkg/**/*",
  "vendor/**/*",
  "spec/**/*",
]

Rake::Task[:lint].clear

PuppetLint.configuration.relative = true
PuppetLint.configuration.disable_arrow_alignment
PuppetLint.configuration.disable_80chars
PuppetLint.configuration.disable_class_inherits_from_params_class
PuppetLint.configuration.disable_class_parameter_defaults
PuppetLint.configuration.disable_documentation
PuppetLint.configuration.disable_single_quote_string_with_variables
PuppetLint.configuration.fail_on_warnings = true

PuppetLint::RakeTask.new :lint do |config|
  config.ignore_paths = exclude_paths
end

PuppetSyntax.exclude_paths = exclude_paths

desc "Run acceptance tests"
RSpec::Core::RakeTask.new(:acceptance) do |t|
  t.pattern = 'spec/acceptance'
end

desc "Populate CONTRIBUTORS file"
task :contributors do
  system("git log --format='%aN' | sort -u > CONTRIBUTORS")
end

desc "Parallel spec tests"
task :parallel_spec do
  Rake::Task[:spec_prep].invoke
  ParallelTests::CLI.new.run('--type test -t rspec spec/classes spec/defines spec/unit spec/functions'.split)
  Rake::Task[:spec_clean].invoke
end

desc "Run syntax, lint, and spec tests."
task :test => [
  :metadata_lint,
  :syntax,
  :lint,
  :spec,
]

GitHubChangelogGenerator::RakeTask.new :changelog do |config|
  version = (Blacksmith::Modulefile.new).version
  config.future_release = "v#{version}"
  config.header = "# Change log\n\nAll notable changes to this project will be documented in this file.\nEach new release typically also includes the latest modulesync defaults.\nThese should not impact the functionality of the module."
  config.exclude_labels = %w{duplicate question invalid wontfix modulesync}
end
