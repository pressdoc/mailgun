require 'mailgun/exception'

module Mailgun
  module API
    class Webhooks
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def all(domain)
        fail(ParameterError, 'No domain given to find on Mailgun', caller) unless domain
        client.get("domains/#{domain}/webhooks")
      end

      def get(domain, webhook)
        fail(ParameterError, 'No domain given to find on Mailgun', caller) unless domain
        fail(ParameterError, 'No webhook given to find on Mailgun', caller) unless webhook
        client.get("domains/#{domain}/webhooks/#{webhook}")
      end

      def add(domain, id, url)
        fail(ParameterError, 'No domain given to find on Mailgun', caller) unless domain
        fail(ParameterError, 'No id for webhook given', caller)  unless id
        fail(ParameterError, 'No url for webhook given', caller) unless url

        client.post("domains/#{domain}/webhooks", { id: id, url: url })
      end
      alias_method :create, :add

      def update(domain, webhook, id, url)
        fail(ParameterError, 'No domain given to find on Mailgun', caller) unless domain
        fail(ParameterError, 'No webhook given to update on Mailgun', caller) unless webhook
        fail(ParameterError, 'No id for webhook given', caller)  unless id
        fail(ParameterError, 'No url for webhook given', caller) unless url

        client.put("domains/#{domain}/webhooks/#{webhook}", { id: id, url: url })
      end

      def delete(domain, webhook)
        fail(ParameterError, 'No domain given to find from Mailgun', caller) unless domain
        fail(ParameterError, 'No webhook given to find from Mailgun', caller) unless webhook
        client.delete("domains/#{domain}/webhooks/#{webhook}")
      end
      alias_method :remove, :delete
    end
  end
end