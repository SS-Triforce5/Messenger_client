require 'http'

# Returns an authenticated user, or nil
class FindAuthenticatedAccount
  HOST = 'http://incredibly-safe-messenger-api.herokuapp.com'

  def self.call(username:, password:)
    response = HTTP.get("#{HOST}/api/v1/account/#{username}/authenticate",
                        params: {password: password})
    response.code == 200 ? JSON.parse(response) : nil
  end
end
