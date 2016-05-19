require 'sinatra'
require 'rack-flash'

# Basec class for Messenger Web Application
class MessengerApp < Sinatra::Base
  enable :logging

  use Rack::Session::Cookie, secret: ENV['MSG_KEY']
  use Rack::Flash

  set :views, File.expand_path('../../views', __FILE__)
  set :public_dir, File.expand_path('../../public', __FILE__)

  before do
    @current_account = session[:current_account]
  end

  get '/' do
    slim :home
  end
end
