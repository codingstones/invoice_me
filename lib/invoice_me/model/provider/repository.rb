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
      deserialize(found)
    end

    private

    def deserialize(raw)
      Provider.new(
        id: raw["id"],
        cif: raw["cif"],
        password: raw["personal_comment"])
    end
  end
end
