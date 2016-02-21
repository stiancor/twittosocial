class LikesController < ApplicationController
  before_filter :signed_in_user

  def create
    @micropost = Micropost.find(params[:micropost_id])
    @micropost.like!(current_user)
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  def destroy
    @micropost = Like.includes(:micropost).references(:micropost).find(params[:id]).micropost
    @micropost.unlike!(current_user)
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

end