describe "Invoice Repository" do
  let(:a_document_number) {'foo'}
  let(:a_provider_id) { 348489 }
  let(:an_invoice_id) {'an id'}
  let(:a_date) {"2017-07-05"}
  let(:a_line) {
    {description: "a expense", base:1000, vat:21, retention:15}
  }

  let(:an_invoice) {
    InvoiceMe::Invoice.new(document_number: a_document_number,
    lines:[a_line])
  }

  let(:a_cuentica_success_response) do
    {
      "id"=>an_invoice_id,
      "date"=> a_date,
      "provider"=>{"id"=>a_provider_id},
      "document_number"=> a_document_number,
      "expense_lines"=>[{"description"=>a_line[:description], "base"=>a_line[:base], "vat"=>a_line[:vat], "retention"=>a_line[:retention]}]
    }
  end

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
        allow(@cuentica_client).to receive(:register_expense).with(an_instance_of(Hash)).and_return(a_cuentica_success_response)

        @new_invoice = @invoice_repository.put(an_invoice)
      end

      it "is stored" do
        expect(@new_invoice.id).to eq an_invoice_id
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
      allow(@cuentica_client).to receive(:get_expenses).with(provider: a_provider_id).and_return([a_cuentica_success_response])
    end

    it "get a list" do
      @invoices = @invoice_repository.find_by_provider(a_provider_id)

      expect(@invoices.first.id).to eq a_cuentica_success_response["id"]
    end
  end
end
