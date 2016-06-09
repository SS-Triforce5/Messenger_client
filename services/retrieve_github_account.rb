require 'http'

# Returns an authenticated user, or nil
class RetrieveGithubAccount
  def self.call(code)
    response = HTTP.headers(accept: 'application/json')
                   .get("#{ENV['API_HOST']}/api/v1/github_account?code=#{code}")
    response.code == 200 ? response.parse : nil
  end
end
