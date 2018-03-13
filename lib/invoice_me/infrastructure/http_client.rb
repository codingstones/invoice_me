module InvoiceMe
  class HttpClient
    require 'uri'
    require 'net/http'
    require 'openssl'
    require 'json'

    def initialize(auth_token)
      @auth_token = auth_token
    end

    def get(endpoint, params={})
      url = URI(endpoint)
      url.query = URI.encode_www_form(params)

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(url)
      request['X-AUTH-TOKEN'] = @auth_token

      response = http.request(request)
      JSON::parse(response.read_body)
    end

    def post(endpoint, params)
      url = URI(endpoint)

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(url, 'Content-Type' => 'application/json')
      request['X-AUTH-TOKEN'] = @auth_token

      request.body = JSON.generate(params)

      response = http.request(request)
      JSON::parse(response.read_body)
    end
  end
end
