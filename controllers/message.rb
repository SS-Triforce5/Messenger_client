require 'sinatra'

# Base class for ConfigShare Web Application
class MessengerApp < Sinatra::Base
  get_message = lambda do
    if @current_account && @current_account['username'] == params[:username]
      @messages = GetAllMessages.call(username: params[:username], auth_token: session[:auth_token])
    end
    @messages ? slim(:all_messages) : redirect('/login')
  end

  get_chatroom = lambda do
    if @current_account
      slim :chatroom
    else
      flash[:notice] = "you must login before you chat with others"
      redirect('/login')
    end
  end

  get '/message/:username/?', &get_message
  get '/message/chatroom/?', &get_chatroom
end
