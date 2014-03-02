class LikesController < ApplicationController
  before_filter :signed_in_user

  def create
    @micropost = Micropost.find(params[:like][:micropost_id])
    @micropost.like!(current_user)
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  def destroy
    @micropost = Like.includes(:micropost).find(params[:id]).micropost
    @micropost.unlike!(current_user)
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

end