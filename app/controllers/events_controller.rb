class EventsController < ApplicationController
  include EventsHelper

  before_filter :signed_in_user
  before_filter :user_is_invited, only: [:edit, :update, :destroy, :show]
  before_filter :user_can_update, only: [:edit, :update, :destroy]

  def index
    @events = Event.includes(:event_invites).references(:event_invites)
    .where('end_time > ? and event_invites.user_id = ?', DateTime.now, current_user.id)
    .paginate(page: params[:page]).order('start_time')
  end

  def old
    @events = Event.includes(:event_invites).references(:event_invites)
    .where('end_time < ? and event_invites.user_id = ?', DateTime.now, current_user.id)
    .paginate(page: params[:page], per_page: 10).order('start_time desc')
  end

  def show
    @event = Event.includes(:event_invites => :user).references(:event_invites, :user).find(params[:id])
    @event_comment = EventComment.new
  end

  def new
    get_users
    @event = Event.new
  end

  def create
    @event = current_user.events.build(event_params)
    @event.user = current_user
    if @event.save
      @event.event_invites.create(user_id: current_user.id, attend_status: 'yes')
      if @event.send_mail
        send_email_to_all_invites(@event)
      end
      flash[:success] = 'Event created!'
      redirect_to events_path
    else
      get_users
      @feed_items = []
      @usernames = User.all.collect { |user| user.username.to_s }.sort
      render 'new'
    end
  end

  def edit
    get_users
  end

  def update
    if @event.update_attributes(event_params)
      if @event.send_mail
        send_email_to_all_invites(@event)
      end
      flash[:success] = 'Event was updated'
      redirect_to events_path
    else
      render 'edit'
    end
  end

  def destroy
    Event.find(params[:id]).destroy
    flash[:success] = 'Event deleted'
    redirect_to events_path
  end

  def join
    Rails.logger.error("JOIN")
  end

  def maybe
    Rails.logger.error("MAYBE")
  end

  def decline
    Rails.logger.error("DECLINE")
  end

  private

  def get_users
    @users = User.where('id != ?', current_user.id).order('name').select('id, name')
  end

  def user_is_invited
    if Event.includes(:event_invites).references(:event_invites).where('events.id = ? and event_invites.user_id = ?', params[:id], current_user.id).length == 0
      flash[:warning] = 'You have no access to this event!'
      redirect_to events_path
    end
  end

  def user_can_update
    if current_user.admin
      @event = Event.find_by_id(params[:id])
    else
      @event = current_user.events.find_by_id(params[:id])
    end
    redirect_to event_path if @event.nil?
  end

  def event_params
    params.require(:event).permit(:title, :location, :start_time, :end_time, :invitation, :send_mail, :invite_all, :user_id, :user_ids)
  end
end
