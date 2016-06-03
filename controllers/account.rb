require 'sinatra'

# Account resource routes
class MessengerApp < Sinatra::Base

  get_user = lambda do
    if @current_account && @current_account['username'] == params[:username]
      @auth_token = session[:auth_token]
      slim(:account)
    else
      slim(:login)
    end
  end


  get '/account/:username', &get_user
end
