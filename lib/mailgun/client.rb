require 'faraday'

module Mailgun
  class Client
    include Mailgun::API
    attr_reader :api_key, :domain

    def initialize(api_key, domain)
      @api_key = api_key
      @domain = domain
    end

    # Perform an HTTP GET request
    def get(path, params = {})
      request(:get, path, params)
    end

    # Perform an HTTP POST request
    def post(path, params = {})
      request(:post, path, params)
    end

    # Perform an HTTP PUT request
    def put(path, params = {})
      request(:put, path, params)
    end

    # Perform an HTTP DELETE request
    def delete(path, params = {})
      request(:delete, path, params)
    end

    def request(method, path, params = {})
      params = params.respond_to?(:to_h) ? params.to_h : params
      response = connection.send(method, path, params)
      fail Mailgun::Exception, response.body if response.status != 200
      Mailgun::Response.new(response)
    end

    def connection
      @connection ||= Faraday.new(url: url) do |conn|
        conn.request :multipart
        conn.request :url_encoded
        conn.adapter adapter
      end
    end

    def adapter
      @adapter ||= Faraday.default_adapter
    end

    def url
      "https://api:#{api_key}@api.mailgun.net/v3/#{domain}"
    end
  end
end