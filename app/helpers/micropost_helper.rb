# encoding: utf-8
require 'mail_helper'

module MicropostHelper
  include MailHelper

  def send_email_if_registered_usernames(sender, message)
    user_names = extract_user_names(message)
    if !user_names.empty?
      emails = get_emails(user_names)
      if !emails.empty?
        send_simple_message(sender, emails, message)
      end
    end
  end

  def extract_user_names(message)
    message.scan(/(\s@\w+|\A@\w+)/).collect{|x| x[0].strip.gsub('@','')}.uniq{|z| z}
  end

  def get_emails(user_names)
    User.where(username: user_names).collect {|x| x.email}
  end

  def micropost_li_class(micropost)
    "class='admin-message'" if micropost.admin_message?
  end

end