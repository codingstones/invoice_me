module Cuentica
  class Invoice
    attr_reader :id

    def initialize(args)
      @id = args["id"]
    end
  end
end
