module Cuentica
  class AuthenticateAUser
    def initialize(provider_service = ProviderService.new(CuenticaClient.new))
      @provider_service = provider_service
    end

    def run(cif, password)
      provider = @provider_service.find_provider(cif)

      provider if password == "password"
    end
  end

  class AddInvoice
    def initialize(cuentica = CuenticaClient.new, invoice_validator = InvoiceValidator.new, provider_service = ProviderService.new(CuenticaClient.new))
      @cuentica = cuentica
      @invoice_validator = invoice_validator
      @provider_service = provider_service
    end

    def run(cif, args)
      args[:date] = args[:date].to_s
      args[:document_type] = 'invoice'
      args[:draft] = false

      amount_to_pay = calculate_total_amount(args[:expense_lines])
      args[:expense_lines] = add_required_info_to_expense_lines(args[:expense_lines])
      args[:payments] = payment_information(args[:date], amount_to_pay)

      @invoice_validator.validate(args)

      args[:provider] = provider_id(cif)

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
      provider = @provider_service.find_provider(cif)
      provider["id"]
    end
  end

  class InvoiceValidator
    require 'dry-validation'

    SCHEMA = Dry::Validation.Schema do
      required(:document_number).filled(:str?)
      required(:date).filled(:str?)
    end

    def validate(args)
      result = SCHEMA.call(args)
      raise InvalidInvoiceError, result.errors if result.failure?
    end
  end
end
