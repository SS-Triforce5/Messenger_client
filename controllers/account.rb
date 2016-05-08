require 'sinatra'

# Base class for ConfigShare Web Application
class MessengerApp < Sinatra::Base
  get_login = lambda do
    slim :login
  end

  post_login = lambda do
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

  get_logout = lambda do
    @current_account = nil
    session[:current_account] = nil
    slim :login
  end

  get_user = lambda do
    if @current_account && @current_account['username'] == params[:username]
      slim(:account)
    else
      slim(:login)
    end
  end

get '/login/?', &get_login
post '/login/?', &post_login
get '/logout/?', &get_logout
get '/account/:username', &get_user
end
