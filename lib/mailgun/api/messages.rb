module Mailgun
  module API
    module Messages
      def send_message(message)
        post("messages", message)
      end
    end
  end
end