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

  def send_forgot_password_message(sender, recipients, message)
    RestClient.post "https://api:#{ENV['MAILGUN_KEY']}@api.mailgun.net/v2/#{ENV['MAILGUN_SERVER']}/messages",
                    :from => "TwittoSocial <no-reply@twittosocial.com>",
                    :to => recipients.join(','),
                    :sender => "TwittoSocial",
                    :subject => "Forgot password on TwittoSocial",
                    :html => forgotten_password_message(sender)
  end

  private

  def build_mentioned_message(sender, message)
    "<html><body>@#{sender} mentioned you in this post at <a href='http://www.twittosocial.com' target='_blank'>TwittoSocial</a>: <br/>#{message} <br/><br/>Check out the message at <a href='http://www.twittosocial.com' target='_blank'>TwittoSocial</a><body></html>"
  end

  def forgotten_password_message(sender)
    "<html><body>Please follow <a href='http://www.twittosocial.com' target='_blank'>this</a> link to set a new password at TwittoSocial<body></html>"
  end

end