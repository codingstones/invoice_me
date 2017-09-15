module Cuentica
  class ProviderService
    def initialize(cuentica_client)
      @cuentica_client = cuentica_client
    end
    
    def find_provider(cif)
      providers = @cuentica_client.get_providers
      providers.find do |provider|
        provider["cif"] == cif
      end
    end
  end
end
