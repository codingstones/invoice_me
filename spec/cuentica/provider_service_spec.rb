describe "Prodiver Service" do
  let(:a_cif) {"12345678Z"}
  let(:a_provider) { {"cif"=> a_cif} }
  before(:each) do
    cuentica_client = instance_double(Cuentica::CuenticaClient)
    @provider_service = Cuentica::ProviderService.new(cuentica_client)

    allow(cuentica_client).to receive(:get_providers).and_return([a_provider])
  end

  it "find a provider" do
    pepito_perez = @provider_service.find_provider(a_cif)

    expect(pepito_perez).to eq a_provider
  end
end
