class StaticPagesController < ApplicationController
  include StaticPagesHelper

  def home
    if signed_in?
      @micropost = current_user.microposts.build
      @user_rank = calculate_user_rank
      if params[:q].present?
        @feed_items = Micropost.search(params[:q]).records.paginate(page: params[:page], per_page: 30)
      else
        @feed_items = current_user.feed.paginate(page: params[:page])
      end
      categorize_feed_on_age
    end
  end

  def help
  end

  def about
  end

  def contact
  end

end
