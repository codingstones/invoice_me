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
end
