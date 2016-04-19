require_relative 'api/domains'
require_relative 'api/messages'

module Mailgun
  module API
    def domains
      Mailgun::API::Domains.new(self)
    end

    def messages
      Mailgun::API::Messages.new(self)
    end
  end
end