require 'json'

module Mailgun
  class Response
    attr_reader :code, :body, :raw_body

    def initialize(params)
      @code = params[:code]
      @body = JSON.parse(params[:body])
      @raw_body = params[:body]
    end
  end
end
