require 'rest_client'

module MailHelper

  def send_simple_message (sender, recipients, message)
    RestClient.post "https://api:#{ENV['MAILGUN_KEY']}@api.mailgun.net/v2/#{ENV['MAILGUN_SERVER']}/messages",
                    :from => "TwittoSocial <no-reply@twittosocial.com>",
                    :to => recipients.join(','),
                    :sender => "TwittoSocial",
                    :subject => "@#{sender} mentioned you at TwittoSocial",
                    :html => build_mentioned_message(sender, message)
  end

  def send_forgot_password_message(recipients, token)
    RestClient.post "https://api:#{ENV['MAILGUN_KEY']}@api.mailgun.net/v2/#{ENV['MAILGUN_SERVER']}/messages",
                    :from => "TwittoSocial <no-reply@twittosocial.com>",
                    :to => recipients,
                    :sender => "TwittoSocial",
                    :subject => "Forgot password on TwittoSocial",
                    :html => forgotten_password_message(token)
  end

  private

  def build_mentioned_message(sender, message)
    "<html><body>@#{sender} mentioned you in this post at <a href='http://www.twittosocial.com' target='_blank'>TwittoSocial</a>: <br/>#{message} <br/><br/>Check out the message at <a href='http://www.twittosocial.com' target='_blank'>TwittoSocial</a><body></html>"
  end

  def forgotten_password_message(token)
    "<html><body>Please follow <a href='#{request.protocol}#{request.host_with_port}/reset_password/#{token}' target='_blank'>this</a> link to set a new password at TwittoSocial<body></html>"
  end

end