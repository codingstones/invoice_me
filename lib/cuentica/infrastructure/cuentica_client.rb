module Cuentica
  class CuenticaClient
    def initialize(client = HttpClient.new)
      @client = client
    end

    def register_expense(args)
      @client.post("https://api.cuentica.com/expense", args)
    end

    def get_providers
      @client.get("https://api.cuentica.com/provider")
    end
  end
end
