describe "Invoice" do
  let(:some_lines) do
    [
      {base: 1000, vat: 21, retention: 15}
    ]
  end
  it "calculates total amount" do
    invoice = Cuentica::Invoice.new(lines: some_lines)

    expect(invoice.total_amount).to eq 1060
  end
end
