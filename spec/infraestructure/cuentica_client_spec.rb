describe 'CuenticaClient' do
  before(:each) do
    @client = InvoiceMe::CuenticaClient.new
  end
  it 'get the providers' do
    providers = @client.get_providers

    expect(providers).not_to be_empty
  end
end
