class EventInvitesController < ApplicationController

  def update
    @event_invite = EventInvite.find(params[:id])
    @event_invite.update_attribute('attend_status', translate_status)
    respond_to do |format|
      format.html { redirect_to @event_invite.event }
      format.js
    end
  end

  private

  def translate_status
    status = params[:commit]
    if status == 'Join'
      'yes'
    elsif status == 'Maybe'
      'maybe'
    elsif status == 'Decline'
      'no'
    end
  end
end
