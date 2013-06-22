class EventsController < ApplicationController

  before_filter :signed_in_user

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
    @event = Event.find(params[:id])
  end

  def destroy
    Event.find(params[:id]).destroy
    flash[:success] = 'Event deleted'
    redirect_to events_path
  end
end
