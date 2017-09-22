module Cuentica
  class Provider
    attr_reader :id, :cif

    def initialize(args)
      @id = args['id']
      @cif = args['cif']
    end

    def ==(obj)
      @cif == obj.cif
    end
  end

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
