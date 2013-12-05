class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @micropost = current_user.microposts.build
      if params[:q].present?
        @feed_items = Micropost.search params
      else
        @feed_items = current_user.feed.paginate(page: params[:page])
      end
      post_process_feed()
      @usernames = User.all.collect { |user| user.username.to_s }.sort
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

end
