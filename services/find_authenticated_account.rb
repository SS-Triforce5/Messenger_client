require 'http'

# Returns an authenticated user, or nil
class FindAuthenticatedAccount

  def self.call(username:, password:)
    response = HTTP.get("#{ENV['API_HOST']}/api/v1/account/#{username}/authenticate",
                        params: {password: password})
    response.code == 200 ? JSON.parse(response) : nil
  end
end
