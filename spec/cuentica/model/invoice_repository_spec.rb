describe "Invoice Repository" do
  let(:an_invoice) {Cuentica::Invoice.new(document_number: 'foo', lines:[])}
  let(:an_invoice_id) {"an id"}

  before(:each) do
    @cuentica_client = instance_double(Cuentica::CuenticaClient)
    @invoice_repository = Cuentica::InvoiceRepository.new(@cuentica_client)

    allow(@cuentica_client).to receive(:register_expense).with(an_instance_of(Hash)).and_return("id" => an_invoice_id)
  end

  it "puts an invoice" do
    new_invoice = @invoice_repository.put(an_invoice)

    expect(new_invoice.id).to eq an_invoice_id
  end

end
