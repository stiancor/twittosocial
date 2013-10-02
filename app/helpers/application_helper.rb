module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = 'TwittoSocial'
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def events_summary
    @event_summary = Event.includes(:event_invites)
    .where('end_time > ? and event_invites.user_id = ?', DateTime.now, current_user.id)
    .count(:group => 'attend_status')
    "Events (#{unanswered_invites}/#{probably_attending}/#{total_upcoming_events})"
  end

  private

  def total_upcoming_events
    @event_summary['no_reply'].to_i + @event_summary['no'].to_i + @event_summary['yes'].to_i + @event_summary['maybe'].to_i
  end

  def probably_attending
    @event_summary['yes'].to_i + @event_summary['maybe'].to_i
  end

  def unanswered_invites
    @event_summary['no_reply'] ? "<span class='badge badge-important'>#{@event_summary['no_reply'].to_i}</span>" : 0
  end

end
