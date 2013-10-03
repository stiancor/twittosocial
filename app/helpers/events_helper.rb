module EventsHelper
  include MailHelper

  def send_email_to_all_invites(event)
    all_emails = all_invites(event)
    all_emails << event.user.email
    Rails.logger.info("Trying to send event invite to #{all_emails.join(',')}")
    send_event_invite(event, all_emails, "#{event.user.name} invited you to #{event.title}")
  end

  def all_invites(event)
    event.users.collect { |user|
      user.email
    }
  end
end
