class EventsController < ApplicationController

  before_filter :signed_in_user
  before_filter :user_has_access, only: [:edit, :update, :destroy]

  def index
    @events = Event.where('end_time > ?', DateTime.now).paginate(page: params[:page]).order('start_time')
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
  end

  def create
    @event = current_user.events.build(params[:event])
    if @event.save
      flash[:success] = 'Event created!'
      redirect_to events_path
    else
      @feed_items = []
      @usernames = User.all.collect { |user| user.username.to_s }.sort
      render 'new'
    end
  end

  def edit
  end

  def update
    if @event.update_attributes(params[:event])
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

  private

  def user_has_access
    if current_user.admin
      @event = Event.find_by_id(params[:id])
    else
      @event = current_user.events.find_by_id(params[:id])
    end
    redirect_to event_path if @event.nil?
  end
end
