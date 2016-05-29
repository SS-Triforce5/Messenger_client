require 'sinatra'
require 'slim'
require 'http'

# Base class for ConfigShare Web Application
class MessengerApp < Sinatra::Base
  get_all_message = lambda do
    if @current_account && @current_account['username'] == params[:username]
      @messages = GetAllMessages.call(username: params[:username],
                                      auth_token: session[:auth_token])
    end
    @messages ? slim(:all_messages) : redirect('/login')
  end

  get_chatroom = lambda do
    if @current_account
      response = HTTP.auth("Bearer #{session[:auth_token]}")
                       .get("#{ENV['API_HOST']}/api/v1/account/")
      @all_users = response.parse
      slim :chatroom
    else
      flash[:notice] = "you must login before you chat with others"
      redirect('/login')
    end
  end

  get_message = lambda do
    Slim::Template.new('views/message.slim').render(Object.new)
  end

  get '/message/:username/?', &get_all_message
  get '/message/:username/chatroom/?', &get_chatroom
  get '/message/:sender/chatroom/:receiver/?', &get_message

end
