require 'pony'

class EmailRegistrationVerification
  def self.call(username:, email:)
    registration = { username: username, email: email }
    token_encrypted = SecureMessage.encrypt(registration)

    Pony.mail(to: registration[:email],
              subject: "One more step to activate your ISM account",
              html_body: registration_email(token_encrypted))
  end

  private

  def self.registration_email(token)
    verification_url = "#{ENV['APP_HOST']}/register/#{token}/verify"

    <<~END_EMAIL
      <H1>Incredibly Safe Messenger Registration Received<H1>
      <p>Please <a href=\"#{verification_url}\">click here</a> to validate your
      email. You will be asked to set a password to activate your account.</p>
      <p> If you have never registed our service, PLEASE IGNORE THIS MAIL </p>
    END_EMAIL
  end
end
