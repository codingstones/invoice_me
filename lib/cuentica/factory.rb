module InvoiceMe
  class Factory
    def http_client
      @http_client ||= HttpClient.new(ENV['AUTH_TOKEN'])
    end

    def cuentica_client
      @cuentica_client ||= CuenticaClient.new(http_client)
    end

    def provider_repository
      @provider_repository ||= ProviderRepository.new(cuentica_client)
    end

    def invoice_repository
      @invoice_repository ||= InvoiceRepository.new(cuentica_client)
    end

    def invoice_validator
      @invoice_validator ||= InvoiceValidator.new
    end

    def authenticate_a_user_action
      @authenticate_a_user_action ||= AuthenticateAUser.new(provider_repository)
    end

    def add_invoice_action
      @add_invoice_action ||= AddInvoice.new(invoice_repository, invoice_validator)
    end
  end
end
