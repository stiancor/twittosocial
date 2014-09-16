require 'rest_client'

module MailHelper

  def send_mentioned_message(sender, recipients)
    RestClient.post "https://api:#{ENV['MAILGUN_KEY']}@api.mailgun.net/v2/#{ENV['MAILGUN_SERVER']}/messages",
                    :from => "TwittoSocial <no-reply@twittosocial.com>",
                    :to => recipients.join(','),
                    :sender => "TwittoSocial",
                    :subject => "@#{sender} mentioned you at TwittoSocial",
                    :html => render_to_string('microposts/mention', layout: 'layouts/email')
  end

  def send_event_mentioned_message(sender, recipients)
    RestClient.post "https://api:#{ENV['MAILGUN_KEY']}@api.mailgun.net/v2/#{ENV['MAILGUN_SERVER']}/messages",
                    :from => "TwittoSocial <no-reply@twittosocial.com>",
                    :to => recipients.join(','),
                    :sender => "TwittoSocial",
                    :subject => "@#{sender} mentioned you in an event comment at TwittoSocial",
                    :html => render_to_string('events/mention', layout: 'layouts/email')
  end

  def send_forgot_password_message(recipients, token)
    RestClient.post "https://api:#{ENV['MAILGUN_KEY']}@api.mailgun.net/v2/#{ENV['MAILGUN_SERVER']}/messages",
                    :from => "TwittoSocial <no-reply@twittosocial.com>",
                    :to => recipients,
                    :sender => "TwittoSocial",
                    :subject => "Forgot password on TwittoSocial",
                    :html => forgotten_password_message(token)
  end

  def send_event_invite(recipients, subject)
    RestClient.post "https://api:#{ENV['MAILGUN_KEY']}@api.mailgun.net/v2/#{ENV['MAILGUN_SERVER']}/messages",
                    :from => "TwittoSocial <no-reply@twittosocial.com>",
                    :to => recipients.join(','),
                    :sender => "TwittoSocial",
                    :subject => subject,
                    :html => render_to_string('events/invite', layout: 'layouts/email')
  end

  private

  def forgotten_password_message(token)
    "<html><body>Please follow <a href='#{request.protocol}#{request.host_with_port}/reset_password/#{token}' target='_blank'>this</a> link to set a new password at TwittoSocial<body></html>"
  end

end