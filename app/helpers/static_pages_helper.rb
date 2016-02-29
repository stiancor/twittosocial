module StaticPagesHelper

  def calculate_user_rank
    micropost_rank = Micropost.unscoped.select('user_id, count(id) micropost_count').where('created_at > ?', Date.today.advance(days: -30)).group('user_id').to_a
    event_rank = Event.select('user_id, count(id) event_count').where('start_time between ? and ?', Date.today.advance(days: -14), Date.today.advance(days: 30)).group('user_id').to_a
    event_comment_rank = EventComment.unscoped.select('user_id, count(id) event_comment_count').where('created_at > ?', Date.today.advance(days: -30)).group('user_id').to_a
    like_rank = Micropost.unscoped.select('microposts.user_id micropost_user_id, likes.user_id like_user_id').joins(:likes).where('microposts.created_at > ? and microposts.user_id != likes.user_id', Date.today.advance(days: -30)).to_a
    create_rank_map(micropost_rank, event_rank, event_comment_rank, like_rank)
  end

  def post_process_feed
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

  def create_rank_map(micropost_rank, event_rank, event_comment_rank, like_rank)
    map = Hash.new
    micropost_rank.each { |rank| map[rank.user_id] = rank.micropost_count * 6 }
    event_rank.each { |rank| map[rank.user_id] = map[rank.user_id].to_i + rank.event_count * 35 }
    event_comment_rank.each { |rank| map[rank.user_id] = map[rank.user_id].to_i + rank.event_comment_count * 4 }
    like_rank.each  do |rank|
      map[rank.micropost_user_id] = map[rank.micropost_user_id].to_i + 1
      map[rank.like_user_id] = map[rank.like_user_id].to_i + 1
    end
    sorted_on_rank = Hash[map.sort_by{|k,v| v}].collect {|k,v| k}.reverse
    logger.info("Current rank: #{map}")
    Hash[sorted_on_rank.collect.with_index { |x,i| [x, i + 1] } ]
  end
end
