module Cuentica
  class FindAProvider
    def initialize(client = HttpClient.new)
      @client = client
    end

    def run(cif)
      providers = @client.get("https://api.cuentica.com/provider")
      provider = providers.find do |provider|
        provider["cif"] == cif
      end
      return provider
    end
  end

  class AddInvoice
    def initialize(client = HttpClient.new)
      @client = client
    end

    def run(params)
      cif = params.delete(:cif)
      params[:provider] = provider_id(cif)
      params[:date] = params[:date].to_s
      params[:document_type] = 'invoice'
      params[:draft] = false

      amount_to_pay = calculate_total_amount(params[:expense_lines])
      params[:expense_lines] = add_required_info_to_expense_lines(params[:expense_lines])
      params[:payments] = payment_information(params[:date], amount_to_pay)
      invoice = @client.post("https://api.cuentica.com/expense", params)
    end

    private
    def calculate_total_amount(expense_lines)
      total_amount = 0
      expense_lines.each do |expense|
        base = expense[:base]
        vat = expense[:vat]
        retention = expense[:retention]

        vat_amount = base*vat/100
        retention_amount = base*retention/100

        amount = base + (vat_amount - retention_amount)
        total_amount += amount
      end
      total_amount
    end

    def add_required_info_to_expense_lines(expense_lines)
      expense_lines.each do |expense_line|
        expense_line[:expense_type] = "600"
        expense_line[:investment] = false
        expense_line[:imputation] = 100
      end
      expense_lines
    end

    def payment_information(date, total_amount)
      [{date: date, amount: total_amount, payment_method: 'wire_transfer', paid: false, origin_account: 37207}]
    end

    def provider_id(cif)
      provider = FindAProvider.new().run(cif)
      provider["id"]
    end
  end

  class HttpClient
    require 'uri'
    require 'net/http'
    require 'openssl'
    require 'json'


    def get(endpoint)
      url = URI(endpoint)

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(url)
      request['X-AUTH-TOKEN'] = ENV['AUTH_TOKEN']

      response = http.request(request)
      JSON::parse(response.read_body)
    end

    def post(endpoint, params)
      url = URI(endpoint)

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(url, 'Content-Type' => 'application/json')
      request['X-AUTH-TOKEN'] = ENV['AUTH_TOKEN']

      request.body = JSON.generate(params)

      response = http.request(request)
      JSON::parse(response.read_body)
    end
  end
end
