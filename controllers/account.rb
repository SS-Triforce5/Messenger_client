require 'sinatra'

# Base class for ConfigShare Web Application
class MessengerApp < Sinatra::Base
  get '/login/?' do
    slim :login
  end

  post '/login/?' do
    username = params[:username]
    password = params[:password]

    @current_account = FindAuthenticatedAccount.call(
      username: username, password: password)

    if @current_account
      session[:current_account] = @current_account
      slim :home
    else
      slim :login
    end
  end

  get '/logout/?' do
    @current_account = nil
    session[:current_account] = nil
    slim :login
  end

  get '/account/:username' do
    if @current_account && @current_account['username'] == params[:username]
      slim(:account)
    else
      slim(:login)
    end
  end

  get '/register' do
    slim(:register)
  end
end
