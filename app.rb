require 'sinatra'
require './lib/invoice_me'

factory = InvoiceMe::Factory.new
add_invoice_action = factory.add_invoice_action
autenticate_a_user = factory.authenticate_a_user_action

enable :sessions

def is_authenticated!
  redirect '/login' unless session[:current_user]
end

get '/login' do
  erb :login, :locals => {:errors => nil}
end

post '/login' do
  user = autenticate_a_user.run(params[:user], params[:password])
  if user
    session[:current_user] = user
    redirect '/'
  else
    status 422
    erb :login, :locals => {:errors => ['Invalid User']}
  end
end

get '/' do
  is_authenticated!

  erb :index, :locals => {:errors => nil}
end

post '/' do
  is_authenticated!

  provider_id = session[:current_user].id

  if params[:file]
    filename = params[:file][:filename]
    file = params[:file][:tempfile]

    params[:attachment] = {
      filename: filename,
      data: file.read
    }
  end

  lines = []
  if params[:description]
    params[:description].each_with_index do |description, index|
      line = {}
      line[:description] = description
      line[:base] = params[:base][index].to_f
      line[:vat] = params[:vat][index].to_i
      line[:retention] = params[:retention][index].to_i
      lines.push(line)
    end
  end
  params[:lines] = lines

  begin
    invoice = add_invoice_action.run(provider_id, params)
    redirect '/'
  rescue InvoiceMe::InvalidInvoiceError => e
    status 422
    erb :index, :locals => {:errors => e.messages}
  end
end
