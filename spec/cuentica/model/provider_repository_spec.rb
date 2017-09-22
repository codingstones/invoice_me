describe "Prodiver Repository" do
  let(:a_cif) {"12345678Z"}
  let(:a_cuentica_provider) { {"cif"=> a_cif} }
  let(:found_provider) { Cuentica::Provider.new('cif' => a_cif) }

  before(:each) do
    cuentica_client = instance_double(Cuentica::CuenticaClient)
    @provider_repository = Cuentica::ProviderRepository.new(cuentica_client)

    allow(cuentica_client).to receive(:get_providers).and_return([a_cuentica_provider])
  end

  it "find a provider" do
    pepito_perez = @provider_repository.get(a_cif)

    expect(pepito_perez).to eq found_provider
  end
end
