module Cuentica
  class Invoice
    attr_reader :id, :document_number, :lines, :date

    def initialize(args)
      @id = args[:id]
      @lines = args[:lines]
      @date = args[:date]
      @document_number = args[:document_number]
    end

    def total_amount
      total_amount = 0
      @lines.each do |line|
        base = line[:base]
        vat = line[:vat]
        retention = line[:retention]

        vat_amount = base*vat/100
        retention_amount = base*retention/100

        amount = base + (vat_amount - retention_amount)
        total_amount += amount
      end
      total_amount
    end
  end
end
