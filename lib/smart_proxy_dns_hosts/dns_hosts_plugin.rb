require 'smart_proxy_dns_hosts/dns_hosts_version'

module Proxy::Dns::Hosts
  class Plugin < ::Proxy::Provider
    plugin :dns_hosts, ::Proxy::Dns::Hosts::VERSION,
           :factory => proc { |attrs| ::Proxy::Dns::Hosts::Record.record(attrs) }

    requires :dns, '>= 0' #, ::Proxy::VERSION

    after_activation do
      require 'smart_proxy_dns_hosts/dns_hosts_main'
    end
  end
end
