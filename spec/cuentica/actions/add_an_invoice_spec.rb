describe "Add An Invoice" do
  let(:provider_id) {"12345678Z"}
  let(:a_day) {Date.today}
  let(:an_amount) {1000}
  let(:some_expense_lines) do
    [{description: 'a expense', base: an_amount, vat: 21, retention: 15}]
  end
  let(:a_invoice_number) {'17/2017'}
  let(:an_attachment){ {filename: a_invoice_number, data: 'irrelevant data'} }

  before(:each) do
    @add_invoice = Cuentica::Factory.new.add_invoice_action
  end

  context "with valid data" do
    before(:each) do
      VCR.use_cassette("add_invoice") do
        @result = @add_invoice.run(provider_id, date: a_day,
            lines: some_expense_lines, document_number: a_invoice_number,
            attachment: an_attachment)
      end
    end
    it "adds the invoice" do
      expect(@result).not_to be_nil
      expect(@result.id).not_to be_nil
    end
  end

  context "fails" do
    it "without invoice number" do
      VCR.use_cassette("add_invoice") do
      expect{@add_invoice.run(provider_id, date: a_day,
        expense_lines: some_expense_lines)}.to raise_error(Cuentica::InvalidInvoiceError)
      end
    end

    it "without date" do
      VCR.use_cassette("add_invoice") do
      expect{@add_invoice.run(provider_id, expense_lines: some_expense_lines,
        document_number: a_invoice_number)}.to raise_error(Cuentica::InvalidInvoiceError)
      end
    end
  end


end
