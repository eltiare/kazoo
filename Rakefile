require 'rubygems'
require 'rake'
require 'echoe'

require 'rspec'
require 'rspec/core/rake_task'

Echoe.new('kazoo', '0.0.6') do |p|
  p.description    = "A moduler framework to facilitate the development of content management systems"
  p.url            = "http://rubykazoo.com"
  p.author         = "Jeremy Nicoll"
  p.email          = "jnicoll @nspam@ accentuate.me"
  p.ignore_pattern = ['*.kpf', "tmp/*", "script/*"]
  p.development_dependencies = []
end


desc "Run all specs"
RSpec::Core::RakeTask.new(:spec)
task :default => :spec
