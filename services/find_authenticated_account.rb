require 'http'
# Returns an authenticated account, or nil
#   args: credentials (LoginCredentials)
#   return: account (Hash)class FindAuthenticatedAccount
class FindAuthenticatedAccount
def self.call(credentials)
    response = HTTP.post("#{ENV['API_HOST']}/api/v1/account/authenticate",
    body: SecureMessage.sign(credentials.to_hash))
    response.code == 200 ? JSON.parse(response) : nil
  end
end
