describe "Invoice Repository" do
  let(:a_provider_id) { 348489 }

  let(:a_document_number) {'foo'}
  let(:a_date) {"2017-07-05"}
  let(:a_line) {
    {description: "a expense", base:1000, vat:21, retention:15}
  }

  let(:an_invoice) {
    InvoiceMe::Invoice.new(document_number: a_document_number,
    lines:[a_line])
  }

  let(:a_cuentica_error_response) do
    {"message"=>"A server error occurred, please try again later"}
  end

  before(:each) do
    @cuentica_client = instance_double(InvoiceMe::CuenticaClient)
    @invoice_repository = InvoiceMe::InvoiceRepository.new(@cuentica_client)
  end

  context "puts an invoice" do
    context "with success" do
      before(:each) do
        @invoice_repository = InvoiceMe::InvoiceRepository.new(InvoiceMe::CuenticaClient.new)
        VCR.use_cassette("add_invoice") do
          @new_invoice = @invoice_repository.put(an_invoice)
        end
      end

      it "is stored" do
        expect(@new_invoice.id).not_to be_nil
      end
    end

    context "with error" do
      before(:each) do
        allow(@cuentica_client).to receive(:register_expense).with(an_instance_of(Hash)).and_return(a_cuentica_error_response)
      end

      it "is not stored" do
        expect{@new_invoice = @invoice_repository.put(an_invoice)}.to raise_error(InvoiceMe::InvalidInvoiceError)
      end
    end
  end

  context "get invoices by provider" do
    before(:each) do
      @invoice_repository = InvoiceMe::InvoiceRepository.new(InvoiceMe::CuenticaClient.new)
    end

    it "get a list" do
      VCR.use_cassette("find_expenses") do
        invoices = @invoice_repository.find_by_provider(a_provider_id)

        expect(invoices).not_to be_empty
        expect(invoices.first.provider_id).to eq a_provider_id
      end
    end
  end
end
