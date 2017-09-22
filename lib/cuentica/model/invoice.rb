module Cuentica
  class Invoice
    attr_reader :id

    def initialize(args)
      @id = args["id"]
      @expense_lines = args[:expense_lines]
    end

    def total_amount
      total_amount = 0
      @expense_lines.each do |expense|
        base = expense[:base]
        vat = expense[:vat]
        retention = expense[:retention]

        vat_amount = base*vat/100
        retention_amount = base*retention/100

        amount = base + (vat_amount - retention_amount)
        total_amount += amount
      end
      total_amount
    end
  end
end
