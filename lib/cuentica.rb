module Cuentica
  class FindAProvider
    def run(cif)
      providers = Client::get("https://api.cuentica.com/provider")
      provider = providers.find do |provider|
        provider["cif"] == cif
      end
      return provider
    end
  end

  class Client
    require 'uri'
    require 'net/http'
    require 'openssl'
    require 'json'

    def self.get(endpoint)
      url = URI(endpoint)

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(url)
      request['X-AUTH-TOKEN'] = ENV['AUTH_TOKEN']

      response = http.request(request)
      JSON::parse(response.read_body)
    end
  end
end
