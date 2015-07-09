require 'augeas'

module Proxy::Dns::Hosts
  class Record < ::Proxy::Dns::Record
    include Proxy::Log
    include Proxy::Util

    attr_reader :file

    def self.record(attrs = {})
      new(attrs.merge(:file => ::Proxy::Dns::Hosts::Plugin.settings.hosts_file))
    end

    def initialize options = {}
      @file = options[:file]
      raise "DNS hosts provider needs 'hosts_file' option" unless file
      super(options)
    end

    def create
      if @type == 'A'
        augeas do |aug|
          if aug.match("*[ipaddr='#{@value}']").any?
            aug.set("*[ipaddr='#{@value}']/alias[last()+1]", @fqdn)
          else
            aug.set('./01/ipaddr', @value)
            aug.set('./01/canonical', @fqdn)
          end
          aug.save
        end
        true
      else
        logger.warn "not creating #{@type} record for #{@fqdn} (unsupported)"
      end
    end

    def remove
      if @type == 'A'
        augeas do |aug|
          aug.rm("*/alias[.='#{@fqdn}']")
          aug.rm("*[canonical='#{@fqdn}']")
          aug.save
        end
        true
      else
        logger.warn "not deleting #{@type} record for #{@fqdn} (unsupported)"
      end
    end

    private

    def augeas(&block)
      aug = Augeas::open(nil, nil, Augeas::NO_MODL_AUTOLOAD)
      aug.set('/augeas/load/Xfm/lens', 'Hosts.lns')
      aug.set('/augeas/load/Xfm/incl', file)
      aug.set('/augeas/context', "/files#{file}")
      aug.load
      yield(aug)

      if aug.match('/augeas//error').any?
        aug.match('/augeas//error//*').each do |e|
          puts "#{e}: #{aug.get(e)}"
        end
      end
    ensure
      aug.close if aug
    end
  end
end
