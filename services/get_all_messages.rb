require 'http'

# Returns an authenticated user, or nil
class GetAllMessages
  def self.call(username: , auth_token:)
    response = HTTP.auth("Bearer #{auth_token}")
                    .get("#{ENV['API_HOST']}/api/v1/message/#{username}")

    response.code == 200 ? extract_message(response.parse) : nil
  end

  def self.extract_message(messages)
    messages.map do |mes|
      {
        id: mes['id'],
        sender: mes['data']['sender'],
        receiver: mes['data']['receiver'],
        message: mes['data']['message'],
        time: mes['data']['time']
      }
    end
  end
end
