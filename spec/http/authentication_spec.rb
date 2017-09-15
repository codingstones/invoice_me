describe 'Authentication' do
  it 'login form is shown' do
    get '/login'

    expect(last_response).to be_ok
  end

  let(:credentials) { {user: '12345678Z', password: 'password'} }

  context 'authenticates ok' do
    it 'redirects to invoices' do
      VCR.use_cassette("find_a_provider") do
        post '/login', credentials
        
        expect(last_response).to be_redirect
      end
    end
  end
end
