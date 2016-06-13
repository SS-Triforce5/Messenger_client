require 'sinatra'

class MessengerApp < Sinatra::Base

get_register = lambda do
  slim(:register)
end

sending_registration_email = lambda do
  registration = Registration.call(params)
  if registration.failure?
    flash[:error] = 'Please enter a valid username and email'
    redirect '/register'
    halt
  end
  begin
    EmailRegistrationVerification.call(registration)
    flash[:notice] = 'A verification email has been sent to you: please check'
    redirect '/'
  rescue => e
    logger.error "FAIL EMAIL: #{e}"
    flash[:error] = 'Unable to send email verification -- please '\
                    'check you have entered the right address'
    redirect '/register'
  end
end

token_verification = lambda do
  @token_secure = params[:token_secure]
  @new_account = SecureMessage.decrypt(@token_secure)
  slim :register_confirm
end

submit_token = lambda do
  passwords = Passwords.call(params)
    if passwords.failure?
      flash[:error] = passwords.messages.values.join('; ')
      redirect "/register/#{params[:token_secure]}/verify"
      halt
  end

  new_account = SecureMessage.decrypt(params[:token_secure])
  result = CreateVerifiedAccount.call(
    username: new_account['username'],
    email: new_account['email'],
    password: passwords[:password])
    if result
       flash[:notice] = 'Please login with your new username and password'
       redirect('/login')
     else
       flash[:notice] = 'Your account could not be created; please try again'
       redirect('/register')
     end
end

get '/register', &get_register
post '/register/?', &sending_registration_email
get '/register/:token_secure/verify', &token_verification
post '/register/:token_secure/verify', &submit_token
end
