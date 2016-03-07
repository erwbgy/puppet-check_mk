source ENV['GEM_SOURCE'] || "https://rubygems.org"

group :development, :unit_tests do
  gem 'rake',                    :require => false
  gem 'rspec-puppet',            :require => false
  gem 'puppetlabs_spec_helper',  :require => false
  gem 'puppet-lint',             :require => false
  gem 'metadata-json-lint',      :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

if rspecpuppetversion = ENV['RSPEC_GEM_VERSION']
  gem 'rspec', rspecpuppetversion, :require => false
else
  gem 'rspec', :require => false
end

# vim:ft=ruby
