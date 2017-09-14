require 'sinatra'
require './lib/cuentica'

add_invoice_action = Cuentica::AddInvoice.new

get '/' do
  erb :index
end


post '/' do
  params[:cif] = "12345678Z"
  expense_lines = []
  if params[:description]
    params[:description].each_with_index do |description, index|
      expense_line = {}
      expense_line[:description] = description
      expense_line[:base] = params[:base][index].to_f
      expense_line[:vat] = params[:vat][index].to_i
      expense_line[:retention] = params[:retention][index].to_i
      expense_lines.push(expense_line)
    end
  end
  params[:expense_lines] = expense_lines

  begin
    invoice = add_invoice_action.run(params)
    redirect '/'
  rescue Cuentica::InvalidInvoiceError => e
    status 422
    erb :index, :locals => {:errors => e.messages}
  end
end
