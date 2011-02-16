require 'rubygems'
require 'rake'
require 'echoe'

require 'rspec'
require 'rspec/core/rake_task'

Echoe.new('kazoo', '0.0.3') do |p|
  p.description    = "Make your Ruby Rack apps act like one"
  p.url            = "http://rubykazoo.com"
  p.author         = "Jeremy Nicoll"
  p.email          = "jnicoll @nspam@ accentuate.me"
  p.ignore_pattern = ['*.kpf', "tmp/*", "script/*"]
  p.development_dependencies = []
end


desc "Run all specs"
RSpec::Core::RakeTask.new(:spec)
task :default => :spec
