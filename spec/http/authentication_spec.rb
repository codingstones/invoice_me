describe 'Authentication' do
  it 'login form is shown' do
    get '/login'

    expect(last_response).to be_ok
  end

  context 'authenticates ok' do
    let(:credentials) { {user: '12345678Z', password: 'password'} }
    it 'redirects to invoices' do
      VCR.use_cassette("find_a_provider") do
        post '/login', credentials

        expect(last_response).to be_redirect
      end
    end

    it 'adds a current_user to the session' do
      VCR.use_cassette("find_a_provider") do
        post '/login', credentials

        expect(last_request.env['rack.session'][:current_user]).not_to be_nil
      end
    end
  end

  context 'authenticates ko' do
    let(:credentials) { {user: '12345678Z', password: ''} }
    it 'show errors' do
      VCR.use_cassette("find_a_provider") do
        post '/login', credentials

        expect(last_response.status).to eq 422
      end
    end
  end

  it 'redirects to login if is not authenticated' do
    get '/'

    expect(last_response).to be_redirect
  end
end
