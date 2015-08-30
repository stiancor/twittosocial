require 'mail_helper'

module MessageHelper
  include MailHelper

  def send_email_if_registered_usernames(sender, message)
    user_names = find_users_to_email(message)
    unless user_names.empty?
      emails = get_emails(user_names)
      unless emails.empty?
        Rails.logger.info("Trying to send mail to #{emails.join(',')}")
        send_mentioned_message(sender, emails)
      end
    end
  end

  def send_email_if_mentioned_in_event(sender, event_comment)
    user_names = find_users_in_event_message(event_comment)
    emails = []
    if user_names.empty?
      emails = event_comment.event.event_invites.find_all { |invite| invite.attend_status != 'no' }.collect { |invite| invite.user.email }
    else
      emails = get_emails(user_names)
    end
    unless emails.empty?
      Rails.logger.info("Trying to send mail to #{emails.join(',')}")
      send_event_mentioned_message(sender, emails)
    end
  end

  def find_users_to_email(message)
    if message.match /(\s@alle\b|\A@alle\b)/
      User.select('username').where('username is not null').group('username').all.collect { |x| x.username }
    else
      extract_usernames(message)
    end
  end

  def find_users_in_event_message(event_comment)
    if event_comment.content.match /(\s@alle\b|\A@alle\b)/
      event_comment.event.event_invites.find_all { |i| i.attend_status != 'no' }.collect { |i| i.user.username }
    else
      extract_usernames(event_comment.content)
    end
  end

  def extract_usernames(message)
    message.scan(/(\s@\w+|\A@\w+)/).collect { |x| x[0].strip.gsub('@', '') }.uniq { |z| z }
  end

  def get_emails(user_names)
    User.where(username: user_names).collect { |x| x.email }
  end

end