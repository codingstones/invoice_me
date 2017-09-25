module InvoiceMe
  class ProviderRepository
    def initialize(cuentica_client)
      @cuentica_client = cuentica_client
    end

    def get(cif)
      providers = @cuentica_client.get_providers
      found = providers.find do |provider|
        provider["cif"] == cif
      end
      Provider.new(found)
    end
  end
end
