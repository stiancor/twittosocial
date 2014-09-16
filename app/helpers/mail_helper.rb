require 'rest_client'

module MailHelper

  def send_mentioned_message(sender, recipients, message)
    RestClient.post "https://api:#{ENV['MAILGUN_KEY']}@api.mailgun.net/v2/#{ENV['MAILGUN_SERVER']}/messages",
                    :from => "TwittoSocial <no-reply@twittosocial.com>",
                    :to => recipients.join(','),
                    :sender => "TwittoSocial",
                    :subject => "@#{sender} mentioned you at TwittoSocial",
                    :html => "#{render_to_string 'microposts/mention', locals: {sender: sender, message: message}, layout: 'layouts/email'}"
  end

  def send_event_mentioned_message(sender, recipients, event_comment)
    RestClient.post "https://api:#{ENV['MAILGUN_KEY']}@api.mailgun.net/v2/#{ENV['MAILGUN_SERVER']}/messages",
                    :from => "TwittoSocial <no-reply@twittosocial.com>",
                    :to => recipients.join(','),
                    :sender => "TwittoSocial",
                    :subject => "@#{sender} mentioned you in an event comment at TwittoSocial",
                    :html => "#{render_to_string 'events/mention', locals: {sender: sender, message: event_comment}, layout: 'layouts/email'}"
  end

  def send_forgot_password_message(recipients, token)
    RestClient.post "https://api:#{ENV['MAILGUN_KEY']}@api.mailgun.net/v2/#{ENV['MAILGUN_SERVER']}/messages",
                    :from => "TwittoSocial <no-reply@twittosocial.com>",
                    :to => recipients,
                    :sender => "TwittoSocial",
                    :subject => "Forgot password on TwittoSocial",
                    :html => forgotten_password_message(token)
  end

  def send_event_invite(event, recipients, subject)
    RestClient.post "https://api:#{ENV['MAILGUN_KEY']}@api.mailgun.net/v2/#{ENV['MAILGUN_SERVER']}/messages",
                    :from => "TwittoSocial <no-reply@twittosocial.com>",
                    :to => recipients.join(','),
                    :sender => "TwittoSocial",
                    :subject => subject,
                    :html => event_invite_message(event)
  end

  private

  def build_mentioned_message(sender, message)
    "<html><body>@#{sender} mentioned you in this post at <a href='#{request.protocol}#{request.host_with_port}' target='_blank'>TwittoSocial</a>: <br/>#{message} <br/><br/>Check out the message at <a href='#{request.protocol}#{request.host_with_port}' target='_blank'>TwittoSocial</a><body></html>"
  end

  def forgotten_password_message(token)
    "<html><body>Please follow <a href='#{request.protocol}#{request.host_with_port}/reset_password/#{token}' target='_blank'>this</a> link to set a new password at TwittoSocial<body></html>"
  end

  def event_invite_message(event)
    "<html><body>#{event.user.name} invited you to #{event.title}. Check out the invite at <a href='#{request.protocol}#{request.host_with_port}/events/#{event.id}' target='_blank'>TwittoSocial</a><body></html>"
  end

end