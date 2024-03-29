class EventsController < ApplicationController
  before_action :find_event, except: [:index, :new, :create, :list]
  skip_before_action :authenticate_user!, :only => [:list, :show]
  layout :resolve_layout

  def index
    if current_user.present?
      events_scope = Event.order(starts_at: :desc) # most future = most top

      respond_to do |format|
        format.html {
          smart_listing_create :events, events_scope, partial: 'events/listing', default_sort: { starts_at: :asc }
        }
        format.js { smart_listing_create :events, events_scope, partial: 'events/listing', default_sort: { starts_at: :asc } }
        format.csv { send_data events_scope.to_csv, filename: "events_as_of-#{Time.now}.csv" }
      end
    else
      redirect_to new_event_registration_path(Event.upcoming.first)
    end
  end

  def list
    @events = Event.upcoming # only the upcoming events go here!
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    respond_to do |format|
      if @event.save
        format.json { head :no_content }
        format.js { flash[:success] = 'Event has been created.' }
        format.html {
          flash[:success] = 'Event has been created.'
          redirect_to events_path
        }
      else
        format.json { render json: @event.errors.full_messages, status: :unprocessable_entity }
      end

    end
  end

  def show
  end

  def edit

  end

  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html {
          flash[:sucess] = 'Event has been updated!'
          redirect_to events_path
        }
        format.json { head :no_content }
        format.js { flash[:success] = 'Event has been updated.' }
      else
        format.json { render json: @event.errors.full_messages, status: :unprocessable_entity }
        format.js { render json: @event.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @event.destroy
    respond_to do |format|
      format.js { flash[:success] = 'Event removed.' }
      format.html { redirect_to events_path, notice: 'Event removed.' }
      format.json { head :no_content }
    end
  end

  private

  def resolve_layout
    case action_name
    when "list"
      nil
    when 'show'
      'static_views'
    when 'index', 'edit', 'update', 'destroy'
      "application"
    end
  end

  def find_event
    @event = Event.friendly.find(params[:id])
  end

  def event_params
    params.require(:event).permit!
  end
end
