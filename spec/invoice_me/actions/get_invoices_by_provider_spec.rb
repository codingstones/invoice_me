describe "Get Inovices by Provider" do
  before(:each) do
    @get_invoices_by_provider_action = InvoiceMe::Factory.new.get_invoices_by_provider_action
  end
  it "when the credentials are ok" do
    VCR.use_cassette("find_expenses") do
      pepito_perez = @get_invoices_by_provider_action.run("348489")

      expect(pepito_perez).not_to be_nil
    end
  end
end
