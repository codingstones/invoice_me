module Cuentica
  class FindAProvider
    def initialize(cuentica = CuenticaClient.new)
      @cuentica = cuentica
    end

    def run(cif)
      providers = @cuentica.get_providers
      provider = providers.find do |provider|
        provider["cif"] == cif
      end
      return provider
    end
  end

  class AddInvoice
    def initialize(cuentica = CuenticaClient.new)
      @cuentica = cuentica
    end

    def run(args)
      cif = args.delete(:cif)
      args[:provider] = provider_id(cif)
      args[:date] = args[:date].to_s
      args[:document_type] = 'invoice'
      args[:draft] = false

      amount_to_pay = calculate_total_amount(args[:expense_lines])
      args[:expense_lines] = add_required_info_to_expense_lines(args[:expense_lines])
      args[:payments] = payment_information(args[:date], amount_to_pay)
      invoice = @cuentica.register_expense(args)
    end

    private
    def calculate_total_amount(expense_lines)
      total_amount = 0
      expense_lines.each do |expense|
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

    PROFESSIONAL_SERVICS_EXPENSE_TYPE = "623"
    def add_required_info_to_expense_lines(expense_lines)
      expense_lines.each do |expense_line|
        expense_line[:expense_type] = PROFESSIONAL_SERVICS_EXPENSE_TYPE
        expense_line[:investment] = false
        expense_line[:imputation] = 100
      end
      expense_lines
    end

    def payment_information(date, total_amount)
      [{date: date, amount: total_amount, payment_method: 'wire_transfer', paid: false, origin_account: 37207}]
    end

    def provider_id(cif)
      provider = FindAProvider.new().run(cif)
      provider["id"]
    end
  end
end