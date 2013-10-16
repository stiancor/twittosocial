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
    fetch_event_summary
    "Events (#{unanswered_invites}/#{probably_attending}/#{total_upcoming_events})"
  end

  def event_mobile_summary
    fetch_event_summary
    if @event_summary['no_reply']
      @event_summary['no_reply'] ? "<span class='badge badge-important'>#{@event_summary['no_reply'].to_i}</span>" : ''
    end
  end

  private

  def fetch_event_summary
    @event_summary = Event.includes(:event_invites)
    .where('end_time > ? and event_invites.user_id = ?', DateTime.now, current_user.id)
    .count(:group => 'attend_status')
  end

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
