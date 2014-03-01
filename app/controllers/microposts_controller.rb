# encoding: utf-8
class MicropostsController < ApplicationController
  include MicropostHelper

  before_filter :signed_in_user
  before_filter :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    unless current_user.admin?
      @micropost.admin_message = false
    end
    if @micropost.save
      send_email_if_registered_usernames(current_user.username, @micropost.content)
      flash[:success] = 'Micropost created!'
      redirect_to root_path
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_path
  end

  def who_likes
    @micropost = Micropost.includes(:likes).includes(likes: :user).find(params[:id])
    @users = []
    @micropost.likes.each do |l|
      @users << l.user
    end
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  private

  def correct_user
    @micropost = current_user.microposts.find_by_id(params[:id])
    redirect_to root_path if @micropost.nil?
  end

end