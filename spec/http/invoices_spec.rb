describe 'Invoices' do
  before(:each) do
    get '/new', {}, { 'rack.session' => {
      current_user: InvoiceMe::Provider.new(id: 348489, cif: "12345678Z") }
    }
  end

  it 'get the invoices list' do
    VCR.use_cassette("find_expenses") do
      get '/'

      expect(last_response).to be_ok
    end
  end

  it 'the form is shown' do
    get '/new'

    expect(last_response).to be_ok
  end

  context 'When add an invoice' do
    let(:a_day) {Date.today}
    let(:descriptions) { ['a expense'] }
    let(:bases) { [1000] }
    let(:vats) { [21] }
    let(:retentions){ [15] }
    let(:a_invoice_number) { "17/2017" }
    let(:the_params) do
      {document_number: a_invoice_number, date: a_day, description: descriptions,
       base: bases, vat: vats, retention: retentions}
    end
    it 'redirects' do
      VCR.use_cassette("add_invoice") do
        post '/new', the_params
        expect(last_response).to be_redirect
      end
    end

    context 'invalid' do
      let(:invalid_params) {{foo: 'bar'}}
      it 'show errors' do
        VCR.use_cassette("add_invoice") do
          post '/new', invalid_params
          expect(last_response.status).to eq 422
        end
      end
    end
  end

end
