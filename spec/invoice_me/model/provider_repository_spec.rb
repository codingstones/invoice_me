describe "Prodiver Repository" do
  let(:a_cif) {"12345678Z"}

  before(:each) do
    @provider_repository = InvoiceMe::ProviderRepository.new(InvoiceMe::CuenticaClient.new)
  end

  it "find a provider" do
    VCR.use_cassette("find_a_provider") do
      pepito_perez = @provider_repository.get(a_cif)

      expect(pepito_perez).not_to be_nil
      expect(pepito_perez.cif).to eq a_cif
    end
  end
end
