module InvoiceMe
  class AuthenticateAUser
    def initialize(provider_repository)
      @provider_repository = provider_repository
    end

    def run(username, password)
      if username != "" and password != ""
        provider = @provider_repository.get(username)

        provider if password == provider&.password
      end
    end
  end

  class GetInvoicesByProvider
    def initialize(invoice_repository)
      @invoice_repository = invoice_repository
    end

    def run(provider_id)
      @invoice_repository.find_by_provider(provider_id)
    end
  end

  class AddInvoice
    def initialize(invoice_repository, invoice_validator)
      @invoice_repository = invoice_repository
      @invoice_validator = invoice_validator
    end

    def run(provider_id, args)
      @invoice_validator.validate(args)

      args[:provider_id] = provider_id
      invoice = Invoice.new(args)

      @invoice_repository.put(invoice)
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
