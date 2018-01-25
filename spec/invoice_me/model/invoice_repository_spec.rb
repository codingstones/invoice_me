describe "Invoice Repository" do
  let(:a_provider_id) { 348489 }

  let(:a_document_number) {'foo'}
  let(:a_date) {"2017-07-05"}
  let(:a_line) {
    {description: "a expense", base:1000, vat:21, retention:15}
  }

  before(:each) do
    @invoice_repository = InvoiceMe::InvoiceRepository.new(InvoiceMe::CuenticaClient.new)
  end

  context "puts an invoice" do
    context "with success" do
      before(:each) do
        an_invoice = InvoiceMe::Invoice.new(
          provider_id: a_provider_id,
          document_number: a_document_number,
          date: a_date,
          lines:[a_line]
        )

        VCR.use_cassette("puts_invoice_success") do
          @new_invoice = @invoice_repository.put(an_invoice)
        end
      end

      it "is stored" do
        expect(@new_invoice.id).not_to be_nil
      end

      it "has all their attributes" do
         expect(@new_invoice.document_number).to eq a_document_number
         expect(@new_invoice.date).to eq a_date
         expect(@new_invoice.provider_id).to eq a_provider_id

         line = @new_invoice.lines.first
         expect(line.description).to eq a_line[:description]
         expect(line.base).to eq a_line[:base]
         expect(line.vat).to eq a_line[:vat]
         expect(line.retention).to eq a_line[:retention]
         expect(@new_invoice.id).not_to be_nil
      end
    end

    context "with some external error" do
      it "is not stored" do
        an_invoice = InvoiceMe::Invoice.new(
          document_number: a_document_number,
          date: a_date,
          lines:[a_line]
        )

        VCR.use_cassette("puts_invoice_error") do
          expect{@new_invoice = @invoice_repository.put(an_invoice)}.to raise_error(InvoiceMe::InvalidInvoiceError)
        end
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
