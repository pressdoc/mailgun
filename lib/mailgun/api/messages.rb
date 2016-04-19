module Mailgun
  module API
    class Messages
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def send(message, domain)
        client.post("#{domain}/messages", message)
      end
    end
  end
end