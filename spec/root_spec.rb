describe 'HTTP' do
  context 'GET /' do
    it 'says hello' do
      get '/'

      expect(last_response).to be_ok
    end
  end
end
