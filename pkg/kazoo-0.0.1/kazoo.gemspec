# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{kazoo}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeremy Nicoll"]
  s.cert_chain = ["/Users/eltiare/keys/gem-public_cert.pem"]
  s.date = %q{2011-01-26}
  s.description = %q{Make your Ruby Rack apps act like one}
  s.email = %q{jnicoll @nspam@ accentuate.me}
  s.extra_rdoc_files = ["lib/kazoo.rb", "lib/kazoo/router.rb", "lib/kazoo/sinatra.rb"]
  s.files = ["Manifest", "Rakefile", "lib/kazoo.rb", "lib/kazoo/router.rb", "lib/kazoo/sinatra.rb", "kazoo.gemspec"]
  s.homepage = %q{http://rubykazoo.com}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Kazoo"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{kazoo}
  s.rubygems_version = %q{1.3.7}
  s.signing_key = %q{/Users/eltiare/keys/gem-private_key.pem}
  s.summary = %q{Make your Ruby Rack apps act like one}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
