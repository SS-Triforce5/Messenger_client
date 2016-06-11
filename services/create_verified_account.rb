require 'http'

# Returns an authenticated user, or nil
class CreateVerifiedAccount
  def self.call(username:, email:, password:)
    signed_registration = SecureMessage.sign(
     { username: username, email: email, password: password })

    response = HTTP.post("#{ENV['API_HOST']}/api/v1/account/",
    body: signed_registration)
    response.code == 201 ? true : false
  end
end
