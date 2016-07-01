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

  def calculate_user_rank
    micropost_rank = Micropost.unscoped.select('user_id').where('created_at > ?', Date.today.advance(days: -30)).order('created_at').to_a
    event_rank = Event.joins(:event_invites).select('events.id, events.user_id')
                     .where('start_time between ? and ?', Date.today.advance(days: -14), Date.today.advance(days: 30))
                     .group('events.id, events.user_id').having('count(event_invites.id) > ?', 1).to_a
    event_comment_rank = EventComment.unscoped.select('event_id, user_id').where('created_at > ?', Date.today.advance(days: -30)).order('event_id, created_at').to_a
    like_rank = Micropost.unscoped.select('microposts.user_id micropost_user_id, likes.user_id like_user_id').joins(:likes).where('microposts.created_at > ? and microposts.user_id != likes.user_id', Date.today.advance(days: -30)).to_a
    attending_rank = Event.joins(:event_invites).select('events.id events_id, events.user_id event_user_id, event_invites.user_id event_invite_user_id, event_invites.id ei_id')
                         .where('start_time between ? and ? and attend_status = ? and events.updated_at < start_time', Date.today.advance(days: -14), Date.today.advance(days: 30), 'yes').to_a
    create_rank_map(micropost_rank, event_rank, event_comment_rank, like_rank, attending_rank)
  end

  def categorize_feed_on_age
    one_day_set, two_days_set, three_days_set, one_week_set, two_weeks_set, one_month_set, three_months_set, six_months_set, one_year_set = false
    @feed_items.each_with_index do |f, i|
      days_ago = (Date.today - f.created_at.to_date).to_i
      if days_ago == 1 && !one_day_set
        f.header_message = 'Yesterday'
        one_day_set = true
      elsif days_ago == 2 && !two_days_set
        f.header_message = 'Two days ago'
        two_days_set = true
      elsif days_ago > 2 && days_ago < 7 && !three_days_set
        f.header_message = 'At least 3 days ago'
        three_days_set = true
      elsif days_ago > 6 && days_ago < 15 && !one_week_set
        f.header_message = 'At least one week ago'
        one_week_set = true
      elsif days_ago > 14 && days_ago < 30 && !two_weeks_set
        f.header_message = 'At least two weeks ago'
        two_weeks_set = true
      elsif days_ago > 29 && days_ago < 90 && !one_month_set
        f.header_message = 'At least one month ago'
        one_month_set = true
      elsif days_ago > 90 && days_ago < 180 && !three_months_set
        f.header_message = 'At least three months ago'
        three_months_set= true
      elsif days_ago > 180 && days_ago < 365 && !six_months_set
        f.header_message = 'At least six months ago'
        six_months_set = true
      elsif days_ago > 365 && !one_year_set
        f.header_message = 'At least one year'
        one_year_set = true
      end
    end
  end

  private

  def fetch_event_summary
    @event_summary = Event.includes(:event_invites).references(:event_invites)
    .where('end_time > ? and event_invites.user_id = ?', DateTime.now, current_user.id).group('attend_status').count
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

  def create_rank_map(micropost_rank, event_rank, event_comment_rank, like_rank, attending_rank)
    map = Hash.new(0)
    apply_micropost_score(map, micropost_rank)
    apply_event_score(event_rank, map)
    apply_event_comment_score(event_comment_rank, map)
    apply_like_score(like_rank, map)
    apply_attend_score(attending_rank, map)
    sorted_on_rank = Hash[map.sort_by{|k,v| v}].collect {|k,v| k}.reverse
    logger.info("Current rank: #{map}")
    Hash[sorted_on_rank.collect.with_index { |x,i| [x, i + 1] } ]
  end

  def apply_event_score(event_rank, map)
    event_rank.each { |rank| map[rank.user_id] += 25 }
  end

  def apply_like_score(like_rank, map)
    like_rank.each do |rank|
      map[rank.micropost_user_id] += 1
      map[rank.like_user_id] += 1
    end
  end

  def apply_micropost_score(map, micropost_rank)
    previous_user_id = nil
    adjacent_msg_by_user = 1
    micropost_rank.each do |rank|
      previous_user_id == rank.user_id ? adjacent_msg_by_user += 1 : adjacent_msg_by_user = 1
      if adjacent_msg_by_user < 3
        map[rank.user_id] +=  6
      end
      previous_user_id = rank.user_id
    end
  end

  def apply_event_comment_score(event_comment_rank, map)
    previous_user_id = nil
    previous_event_id = nil
    adjacent_msg_by_user = 1
    event_comment_rank.each do |rank|
      previous_user_id == rank.user_id && previous_event_id == rank.event_id ? adjacent_msg_by_user += 1 : adjacent_msg_by_user = 1
      if adjacent_msg_by_user < 3
        map[rank.user_id] += 4
      end
      previous_user_id = rank.user_id
      previous_event_id = rank.event_id
    end
  end

  def apply_attend_score(attending_rank, map)
    attending_rank.each do |rank|
      if rank.event_user_id != rank.event_invite_user_id
        map[rank.event_invite_user_id] += 15
        map[rank.event_user_id] += 5
      end
    end
  end

end
