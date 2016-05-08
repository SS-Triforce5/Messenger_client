require 'sinatra'

class MessengerApp < Sinatra::Base

get_register = lambda do
  slim(:register)
end

sending_registration_email = lambda do
  begin
    EmailRegistrationVerification.call(
      username: params[:username],
      email: params[:email])
    redirect '/'
  rescue => e
    puts "FAIL EMAIL: #{e}"
    redirect '/register'
  end
end

token_verification = lambda do
  @token_secure = params[:token_secure]
  @new_account = SecureMessage.decrypt(@token_secure)
  slim :register_confirm
end

submit_token = lambda do
  redirect "/register/#{params[:token_secure]}/verify" unless
    (params[:password] == params[:password_confirm]) &&
    !params[:password].empty?

  new_account = SecureMessage.decrypt(params[:token_secure])

  result = CreateVerifiedAccount.call(
    username: new_account['username'],
    email: new_account['email'],
    password: params[:password])

  puts "RESULT: #{result}"
  result ? redirect('/login') : redirect('/register')
end

get '/register', &get_register
post '/register/?', &sending_registration_email
get '/register/:token_secure/verify', &token_verification
post '/register/:token_secure/verify', &submit_token
end
