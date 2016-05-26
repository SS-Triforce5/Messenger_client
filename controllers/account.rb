require 'sinatra'

# Base class for ConfigShare Web Application
class MessengerApp < Sinatra::Base
  get_login = lambda do
    slim :login
  end

  post_login = lambda do
    credentials = LoginCredentials.call(params)

    if credentials.failure?
      flash[:error] = 'Please enter both your username and password'
      redirect '/login'
      halt
    end

    auth_account = FindAuthenticatedAccount.call(credentials)

    if auth_account
      @current_account =auth_account['account']
      session[:auth_token] = auth_account['auth_token']
      session[:current_account] = SecureMessage.encrypt(@current_account)
      flash[:notice] = "Welcome back #{@current_account['username']}"
      redirect '/'
    else
      flash[:error] = 'Your username or password did not match our records'
      slim :login
    end
  end

  get_logout = lambda do
    @current_account = nil
    session[:current_account] = nil
    flash[:notice] = 'You have logged out - please login again to use this site'
    slim :login
  end

  get_user = lambda do
    if @current_account && @current_account['username'] == params[:username]
      @auth_token = session[:auth_token]
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
