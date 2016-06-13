require 'sinatra'

# Account Authentication, Registration, and Authorization
class MessengerApp < Sinatra::Base

get_login = lambda do
  @gh_url = HTTP.get("#{ENV['API_HOST']}/api/v1/github_sso_url").parse['url']
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

get_github_callback = lambda do
  begin
    sso_account = RetrieveGithubAccount.call(params['code'])

    # TODO: DRY out following lines (also in /login controller)
    @current_account = sso_account['account']
    session[:auth_token] = sso_account['auth_token']
    session[:current_account] = SecureMessage.encrypt(@current_account)
    flash[:notice] = "Welcome back #{@current_account['username']}"
    redirect '/'

  rescue => e
    flash[:error] = 'Could not sign in using Github'
    puts "RESCUE: #{e}"
    redirect '/login'
  end
end

get '/login/?', &get_login
post '/login/?', &post_login
get '/logout/?', &get_logout
get '/github_callback/?', &get_github_callback

end
