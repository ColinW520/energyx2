class EventTeamsController < ApplicationController
  before_filter :set_event
  skip_before_action :authenticate_user!, :only => [:show, :new, :create]
  layout :resolve_layout

  def index
    @event.event_teams
  end

  def edit
  end

  def show
    @event_team = EventTeam.find(params[:id])
  end

  def update
    @event_team = EventTeam.find(params[:id])

    respond_to do |format|
      format.html do
        if @event_team.update_attributes(event_team_params)
          flash[:notice] = "Successfully updated this team registration."
          redirect_to event_registrations_path(@event)
        else
          flash[:notice] = "We could not complete this registration. See errors."
          render :edit
        end
      end
    end
  end

  def new
    @event_team = @event.event_teams.new

    2.times { |i| @event_team.registrations.build(event_id: @event.id) }

    gon.stripe_description = "#{@event.name} Team"
  end

  def create
     service_response = CreateTeamForEvent.new(
       event: @event,
       team: EventTeam.new(event_team_params),
       token: params.fetch(:stripe_token, nil)
     ).perform

    @event_team = service_response.object

    respond_to do |format|
      format.html do
        if service_response.success?
          ConfirmationMailer.event_team_registration(@event_team.id).deliver if Rails.env.production?
          flash[:notice] = service_response.message
          redirect_to(event_event_team_path(@event, @event_team))
        else
          flash[:notice] = service_response.message
          render :new
        end
      end
    end
  end

  private

  def resolve_layout
    case action_name
    when "list"
      nil
    when "new", "create", "show"
      "events"
    else
      "application"
    end
  end

  def set_event
    @event = Event.friendly.find params[:event_id]
  end

  def event_team_params
    params.require(:event_team).permit!
  end
end
