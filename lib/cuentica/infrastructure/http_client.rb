module Cuentica
  class HttpClient
    require 'uri'
    require 'net/http'
    require 'openssl'
    require 'json'


    def get(endpoint)
      url = URI(endpoint)

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(url)
      request['X-AUTH-TOKEN'] = ENV['AUTH_TOKEN']

      response = http.request(request)
      JSON::parse(response.read_body)
    end

    def post(endpoint, params)
      url = URI(endpoint)

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(url, 'Content-Type' => 'application/json')
      request['X-AUTH-TOKEN'] = ENV['AUTH_TOKEN']

      request.body = JSON.generate(params)

      response = http.request(request)
      JSON::parse(response.read_body)
    end
  end
end
