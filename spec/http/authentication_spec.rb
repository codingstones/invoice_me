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

  context 'sign out' do
    before(:each) do
      VCR.use_cassette("find_a_provider") do
        post '/login', credentials
      end
    end

    it 'removes current_user to the session' do
      post '/logout'

      expect(last_request.env['rack.session'][:current_user]).to be_nil
    end

    it 'redirects to login' do
      post '/logout'

      expect(last_response).to be_redirect
    end
  end
end
