# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{kazoo}
  s.version = "0.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeremy Nicoll"]
  s.cert_chain = ["/Users/eltiare/keys/gem-public_cert.pem"]
  s.date = %q{2011-03-10}
  s.description = %q{A moduler framework to facilitate the development of content management systems}
  s.email = %q{jnicoll @nspam@ accentuate.me}
  s.extra_rdoc_files = ["lib/kazoo.rb", "lib/kazoo/accessors.rb", "lib/kazoo/app.rb", "lib/kazoo/bouncer.rb", "lib/kazoo/bouncer/authenticator.rb", "lib/kazoo/router.rb", "lib/kazoo/router/app.rb", "lib/kazoo/router/common.rb", "lib/kazoo/router/context.rb", "lib/kazoo/router/dispatch.rb", "lib/kazoo/router/route.rb", "lib/kazoo/sinatra.rb", "lib/kazoo/support.rb"]
  s.files = ["MIT-License", "Manifest", "Rakefile", "kazoo.gemspec", "lib/kazoo.rb", "lib/kazoo/accessors.rb", "lib/kazoo/app.rb", "lib/kazoo/bouncer.rb", "lib/kazoo/bouncer/authenticator.rb", "lib/kazoo/router.rb", "lib/kazoo/router/app.rb", "lib/kazoo/router/common.rb", "lib/kazoo/router/context.rb", "lib/kazoo/router/dispatch.rb", "lib/kazoo/router/route.rb", "lib/kazoo/sinatra.rb", "lib/kazoo/support.rb", "readme.markdown", "spec/router/context_spec.rb", "spec/router/route_spec.rb", "spec/router_spec.rb", "spec/spec.opts", "spec/spec_helper.rb"]
  s.homepage = %q{http://rubykazoo.com}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Kazoo", "--main", "readme.markdown"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{kazoo}
  s.rubygems_version = %q{1.5.0}
  s.signing_key = %q{/Users/eltiare/keys/gem-private_key.pem}
  s.summary = %q{A moduler framework to facilitate the development of content management systems}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
