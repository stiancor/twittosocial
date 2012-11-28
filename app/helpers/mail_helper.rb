require 'rest_client'

module MailHelper

  def send_simple_message (sender, recipients, message)
    RestClient.post "https://api:key-3ax6xnjp29jd6fds4gc373sgvjxteol0@api.mailgun.net/v2/samples.mailgun.org/messages",
                    :from => "Twittosocial <no-reply@twittosocial.com>",
                    :to => recipients.join(','),
                    :subject => "@#{sender} mentioned you at Twittosocial",
                    :html => build_html_document(sender, message)
  end

  private

  def build_html_document(sender, message)
    "<html><body>@#{sender} mentioned you in this post: <br/>#{message} <br/><br/>Check out the message at <a href='http://www.twittosocial.com' target='_blank'>Twittosocial</a><body></html>"
  end
end