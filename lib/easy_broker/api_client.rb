# frozen_string_literal: true

require "uri"
require "net/http"
require "json"
require "openssl"

module EasyBroker
  class ApiError < StandardError
    attr_reader :status, :body

    def initialize(status:, body:)
      @status = status
      @body = body
      super("EasyBroker API error (status: #{status})")
    end
  end

  class ApiClient
    DEFAULT_BASE_URL = "https://api.stagingeb.com"

    def initialize(api_key:, base_url: DEFAULT_BASE_URL)
      @api_key = api_key
      @base_url = base_url
    end

    def get(path, params: {})
      uri = build_uri(path, params)
      response = perform_get(uri)

      raise ApiError.new(status: response.code.to_i, body: response.body) unless response.is_a?(Net::HTTPSuccess)

      JSON.parse(response.body)
    end

    private

    attr_reader :api_key, :base_url

    def build_uri(path, params)
      uri = URI.join(base_url, path)
      uri.query = URI.encode_www_form(params) if params.any?
      uri
    end

    def perform_get(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == "https"
      
      if ENV["DISABLE_SSL_VERIFY"] == "true"
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      request = Net::HTTP::Get.new(uri)
      request["accept"] = "application/json"
      request["X-Authorization"] = api_key

      http.request(request)
    end
  end
end
