module Mailgun
  module API
    module Messages
      def send_message(message, domain)
        post("#{domain}/messages", message)
      end
    end
  end
end