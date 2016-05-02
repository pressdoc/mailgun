require_relative 'api/domains'
require_relative 'api/messages'
require_relative 'api/webhooks'

module Mailgun
  module API
    def domains
      Mailgun::API::Domains.new(self)
    end

    def messages
      Mailgun::API::Messages.new(self)
    end

    def webhooks
      Mailgun::API::Webhooks.new(self)
    end
  end
end