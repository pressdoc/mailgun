require 'mailgun/exception'

module Mailgun
  module API
    class Domains
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def all
        client.get("domains")
      end

      def get(domain)
        fail(ParameterError, 'No domain given to find on Mailgun', caller) unless domain
        client.get("domains/#{domain}")
      end

      def add(domain, options = {})
        fail(ParameterError, 'No domain given to add on Mailgun', caller) unless domain
        options = { smtp_password: nil, spam_action: 'disabled', wildcard: false }.merge(options)
        options[:name] = domain
        client.post('domains', options)
      end
      alias_method :create, :add

      def delete(domain)
        fail(ParameterError, 'No domain given to remove on Mailgun', caller) unless domain
        client.delete("domains/#{domain}")
      end
      alias_method :remove, :delete
    end
  end
end