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
      @all_users = HTTP.auth("Bearer #{session[:auth_token]}")
                     .get("#{ENV['API_HOST']}/api/v1/account/")
                     .parse
                     .sort_by { |user| Time.parse(user['updated_at']) }
                     .reverse
                     .each { |user| user['updated_at'] = relative_time(user['updated_at'])}
      slim :chatroom
    else
      flash[:notice] = "you must login before you chat with others"
      redirect('/login')
    end
  end

  get_message = lambda do
    response = HTTP.auth("Bearer #{session[:auth_token]}")
                   .get("#{ENV['API_HOST']}/api/v1/message/#{params['sender']}/#{params['receiver']}")
                   .parse
                   .map{ |message| message['data']}

    Slim::Template.new('views/message.slim').render(Object.new,
                                             sender: params['sender'],
                                             receiver: params['receiver'],
                                             messages: response)
  end

  get_message_poll = lambda do
    after =  URI.escape(params['after']=='' ? Time.at(0).to_s : (Time.parse(params['after'])+1).to_s)
    response = HTTP.auth("Bearer #{session[:auth_token]}")
                   .get("#{ENV['API_HOST']}/api/v1/message/#{params['sender']}/#{params['receiver']}?after=#{after}")
                   .parse
    response.map do |res|
      message = res['data']
<<-html
<li class="media">
  <div class="media-body">
    <div class="media">
      <a class="pull-left" href="#"><img class="media-object img-circle" src="/img/user.jpeg" /></a>
      <div class="media-body">
        #{message["message"]}
      </div>
      <br /><small class="text-muted">#{message["sender"]} | #{message["time"]}</small>
      <hr />
    </div>
  </div>
</li>
html
    end.join('')
  end

  post_message = lambda do
    if params['message']
      req_body = {sender: params['sender'], receiver: params['receiver'], message: params['message']}
      response = HTTP.auth("Bearer #{session[:auth_token]}")
                     .post("#{ENV['API_HOST']}/api/v1/message/", json: req_body)
    end
  end

  get '/message/:username/?', &get_all_message
  get '/message/:username/chatroom/?', &get_chatroom
  get '/message/:sender/chatroom/:receiver/?', &get_message
  get '/message/:sender/chatroom/:receiver/poll?', &get_message_poll
  post '/message/:sender/chatroom/:receiver/?', &post_message

end
