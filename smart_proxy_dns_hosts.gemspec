require File.expand_path('../lib/smart_proxy_dns_hosts/dns_hosts_version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'smart_proxy_dns_hosts'
  s.version = Proxy::Dns::Hosts::VERSION
  s.summary = "Example DNS provider plugin for Foreman's smart-proxy"
  s.description = 'Extremely simple smart-proxy DNS provider for educational purposes.'
  s.authors = ['Dominic Cleal']
  s.email = 'dcleal@redhat.com'
  s.files = Dir['{lib,settings.d,bundler.d}/**/*'] + ['README', 'LICENSE']
  s.homepage = 'http://github.com/domcleal/smart_proxy_dns_hosts'
  s.license = 'GPLv3'

  s.add_dependency 'ruby-augeas'
end
