# encoding: utf-8
class EventCommentsController < ApplicationController
  include MessageHelper

  before_filter :signed_in_user
  before_filter :correct_user, only: :destroy

  def create
    @event_comment = EventComment.new(user: current_user, event_id: params[:event_id], content: params['event_comment']['content'])
    if @event_comment.save
      send_email_if_mentioned_in_event(current_user.username, @event_comment)
      flash[:success] = 'Comment created!'
      redirect_to @event_comment.event
    end
  end

  def destroy
    event = @event_comment.event
    @event_comment.destroy
    redirect_to event
  end

  private

  def correct_user
    @event_comment = EventComment.find_by_id_and_user_id(params[:id], current_user.id)
    redirect_to root_path if @event_comment.nil?
  end
end
