module Cuentica
  class AuthenticateAUser
    def initialize(provider_repository)
      @provider_repository = provider_repository
    end

    def run(cif, password)
      provider = @provider_repository.get(cif)

      provider if password == "password"
    end
  end

  class AddInvoice
    def initialize(cuentica = CuenticaClient.new, invoice_validator = InvoiceValidator.new, provider_repository = ProviderRepository.new(CuenticaClient.new))
      @cuentica = cuentica
      @invoice_validator = invoice_validator
      @provider_repository = provider_repository
    end

    def run(cif, args)
      @invoice_validator.validate(args)
      invoice = Invoice.new(args)

      expense_args = map_invoice_to_expense(cif, invoice)

      @cuentica.register_expense(expense_args)
    end

    private

    def map_invoice_to_expense(cif, invoice)
      args = {document_type: 'invoice', draft: false}
      args[:document_number] = invoice.document_number
      args[:date] = invoice.date.to_s
      args[:expense_lines] = add_required_info_to_expense_lines(invoice.lines)
      args[:provider] = provider_id(cif)
      args[:payments] = payment_information(args[:date], invoice.total_amount)
      args
    end

    PROFESSIONAL_SERVICES_EXPENSE_TYPE = "623"
    def add_required_info_to_expense_lines(expense_lines)
      expense_lines.each do |expense_line|
        expense_line[:expense_type] = PROFESSIONAL_SERVICES_EXPENSE_TYPE
        expense_line[:investment] = false
        expense_line[:imputation] = 100
      end
      expense_lines
    end

    def payment_information(date, total_amount)
      [{date: date, amount: total_amount, payment_method: 'wire_transfer', paid: false, origin_account: 37207}]
    end

    def provider_id(cif)
      provider = @provider_repository.get(cif)
      provider.id
    end
  end

  class InvoiceValidator
    require 'dry-validation'

    SCHEMA = Dry::Validation.Schema do
      required(:document_number).filled(:str?)
      required(:date).filled
      required(:lines).each do
        schema do
          required(:description).filled(:str?)
          required(:base).filled(:number?)
          required(:vat).filled(:int?)
          required(:retention).filled(:int?)
        end
      end
    end

    def validate(args)
      result = SCHEMA.call(args)
      raise InvalidInvoiceError, result.errors if result.failure?
    end
  end
end
