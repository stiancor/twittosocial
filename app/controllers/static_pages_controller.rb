class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @micropost = current_user.microposts.build
      micropost_rank = User.select('users.*, count(microposts.id) micropost_count').joins(:microposts).where('microposts.created_at > ?', Date.today.advance(days: -30)).group('users.id').order('micropost_count desc').to_a
      event_rank = Event.select('user_id', 'count(events.id) event_count').where('start_time between ? and ?', Date.today.advance(days: -14), Date.today.advance(days: 30)).group('user_id').order('event_count desc').to_a
      @user_rank = create_rank_map(micropost_rank, event_rank)
      if params[:q].present?
        @feed_items = Micropost.search(params[:q]).records.paginate(page: params[:page], per_page: 30)
      else
        @feed_items = current_user.feed.paginate(page: params[:page])
      end
      post_process_feed
    end
  end

  def help
  end

  def about
  end

  def contact
  end

  private

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

  def create_rank_map(micropost_rank, event_rank)
    map = Hash.new
    micropost_rank.each { |rank| map[rank.id] = rank.micropost_count * 3 }
    event_rank.each { |rank| map[rank.user_id] = map[rank.user_id].to_i + rank.event_count * 15 }
    sorted_on_rank = Hash[map.sort_by{|k,v| v}].collect {|k,v| k}.reverse
    Hash[sorted_on_rank.collect.with_index { |x,i| [x, i + 1] } ]
  end

end
