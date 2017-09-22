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
    def initialize(cuentica, invoice_validator, provider_repository)
      @cuentica = cuentica
      @invoice_validator = invoice_validator
      @provider_repository = provider_repository
    end

    def run(provider_id, args)
      @invoice_validator.validate(args)
      
      invoice = Invoice.new(args)

      expense_args = map_invoice_to_expense(provider_id, invoice)

      @cuentica.register_expense(expense_args)
    end

    private

    def map_invoice_to_expense(provider_id, invoice)
      args = {document_type: 'invoice', draft: false}
      args[:document_number] = invoice.document_number
      args[:date] = invoice.date.to_s
      args[:provider] = invoice.provider_id

      args[:expense_lines] = expense_lines_information(invoice.lines)
      args[:payments] = payment_information(invoice)
      args[:attachment] = attachment_information(invoice)
      args
    end

    PROFESSIONAL_SERVICES_EXPENSE_TYPE = "623"
    def expense_lines_information(lines)
      expense_lines = []
      lines.each do |line|
        expense_line = line.to_h
        expense_line[:expense_type] = PROFESSIONAL_SERVICES_EXPENSE_TYPE
        expense_line[:investment] = false
        expense_line[:imputation] = 100
      end
      expense_lines
    end

    def payment_information(invoice)
      date = invoice.date.to_s
      [{date: date, amount: invoice.total_amount, payment_method: 'wire_transfer', paid: false, origin_account: 37207}]
    end

    def attachment_information(invoice)
      require "base64"

      return unless invoice.attachment
      {
        filename: invoice.attachment.filename,
        data: Base64.encode64(invoice.attachment.data)
      }
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
