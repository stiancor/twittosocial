class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      @usernames = User.all.collect { |user| user.username.to_s }.sort
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
