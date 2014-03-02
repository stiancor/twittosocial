class EventCommentsController < ApplicationController

  before_filter :signed_in_user

  def create
    event_comment = EventComment.new(user: current_user, event_id: params[:event_id], content: params['event_comment']['content'])
    if event_comment.save
      flash[:success] = 'Comment created!'
      redirect_to event_comment.event
    end
  end
end
