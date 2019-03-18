require 'faraday'

module Mailgun
  class Client
    include Mailgun::API
    API_HOSTS_PER_REGION = {
      'US' => 'api.mailgun.net',
      'EU' => 'api.eu.mailgun.net'
    }.freeze
    attr_reader :api_key, :api_host

    # API region, default to US region if not provided
    def initialize(api_key, api_region = 'US')
      @api_key = api_key
      @api_host = api_host_from_region(api_region)
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
      response = connection.send(method, path, params) do |request|

      end
      fail Mailgun::Exception, response.body if response.status != 200
      Mailgun::Response.new(code: response.status, headers: response.headers, body: response.body)
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
      "https://api:#{api_key}@#{api_host}/v3/"
    end

    def api_host_from_region(region)
      fail Mailgun::Exception "No region provided" if region.blank?

      api_host = API_HOSTS_PER_REGION[region.upcase]
      fail Mailgun::Exception "No API host found for region provided: #{region}" if api_host.blank?

      api_host
    end
  end
end