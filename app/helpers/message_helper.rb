require 'mail_helper'

module MessageHelper
  include MailHelper

  def send_email_if_registered_usernames(sender, message)
    user_names = extract_user_names(message)
    unless user_names.empty?
      emails = get_emails(user_names)
      unless emails.empty?
        Rails.logger.info("Trying to send mail to #{emails.join(',')}")
        send_mentioned_message(sender, emails)
      end
    end
  end

  def send_email_if_mentioned_in_event(sender, event_comment)
    user_names = extract_user_names(event_comment.content)
    unless user_names.empty?
      emails = get_emails(user_names)
      unless emails.empty?
        Rails.logger.info("Trying to send mail to #{emails.join(',')}")
        send_event_mentioned_message(sender, emails)
      end
    end
  end

  def extract_user_names(message)
    if message.match /(\s@alle\b|\A@alle\b)/
      User.select('username').where('username is not null').group('username').all.collect { |x| x.username }
    else
      message.scan(/(\s@\w+|\A@\w+)/).collect { |x| x[0].strip.gsub('@', '') }.uniq { |z| z }
    end
  end

  def get_emails(user_names)
    User.where(username: user_names).collect { |x| x.email }
  end

end