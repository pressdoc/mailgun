module Mailgun
  class Exception < StandardError
    def initialize(message)
      super(message)
    end
  end

  class ParameterError < Exception; end
end
