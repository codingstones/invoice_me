module InvoiceMe
  class Provider
    attr_reader :id, :cif, :password

    def initialize(args)
      @id = args[:id]
      @cif = args[:cif]
      @password = args[:password]
    end

    def ==(obj)
      @cif == obj.cif
    end
  end
end
