describe "Invoice Repository" do
  let(:a_document_number) {'foo'}
  let(:a_provider_id) { 348489 }
  let(:an_invoice_id) {'an id'}
  let(:a_date) {"2017-07-05"}
  let(:a_line) {
    {description: "a expense", base:1000, vat:21, retention:15}
  }

  let(:an_invoice) {
    Cuentica::Invoice.new(document_number: a_document_number,
    lines:[a_line])
  }

  let(:a_cuentica_response) do
    {
      "id"=>an_invoice_id,
      "date"=> a_date,
      "provider"=>{"id"=>a_provider_id},
      "document_number"=> a_document_number,
      "expense_lines"=>[{"description"=>a_line[:description], "base"=>a_line[:base], "vat"=>a_line[:vat], "retention"=>a_line[:retention]}]
    }
  end

  before(:each) do
    @cuentica_client = instance_double(Cuentica::CuenticaClient)
    @invoice_repository = Cuentica::InvoiceRepository.new(@cuentica_client)

    allow(@cuentica_client).to receive(:register_expense).with(an_instance_of(Hash)).and_return(a_cuentica_response)
  end

  context "puts an invoice" do
    before(:each) do
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

end
