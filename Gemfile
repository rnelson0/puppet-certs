source "https://rubygems.org"

group :test do
  gem "rake"
  gem "puppet", ENV['PUPPET_GEM_VERSION'] || '~> 4.0'
  gem "rspec"
  gem "rspec-puppet"
  gem "puppetlabs_spec_helper"
  gem "metadata-json-lint"
  gem "rspec-puppet-facts"
  gem 'simplecov'
  gem 'coveralls'
  gem "parallel_tests"

  # Common puppet-lint plugins
  gem "puppet-lint-absolute_classname-check"
  gem "puppet-lint-leading_zero-check"
  gem "puppet-lint-trailing_comma-check"
  gem "puppet-lint-version_comparison-check"
  gem "puppet-lint-classes_and_types_beginning_with_digits-check"
  gem "puppet-lint-unquoted_string-check"

  gem "json_pure", '< 2.0.1'

  gem "puppet-blacksmith"

  # Changelog generation gems
  gem 'github_changelog_generator', '~> 1.13.0' if RUBY_VERSION < '2.2.2'
  gem 'github_changelog_generator'              if RUBY_VERSION >= '2.2.2'
  gem 'rack', '~> 1.0'                          if RUBY_VERSION < '2.2.2'
end

group :development do
end

group :system_tests do
  gem "beaker"
  gem "beaker-rspec"
  gem "beaker-puppet_install_helper"
end
