class EventTeamsController < ApplicationController
  before_filter :set_event
  skip_before_action :authenticate_user!, except: [:index]
  layout :resolve_layout

  def index
    @event.event_teams
  end

  def edit
    # for errors
  end

  def show
    @event_team = EventTeam.find(params[:id])
  end

  def update
    @event_team = EventTeam.find(params[:id])

    respond_to do |format|
      format.html do
        if @event_team.update_attributes(event_team_params)
          service_response = ProcessChargeForTeam.new(
            event_team: @event_team,
            stripe_token: params[:stripe_token]
          ).perform

          flash[service_response.flash_status] = service_response.flash_message
          redirect_to service_response.object
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
    @event_team = EventTeam.new(event_team_params)

    respond_to do |format|
      format.html do
        if @event_team.save
          response = ProcessChargeForTeam.new(
            event_team: @event_team,
            stripe_token: params[:stripe_token]
          ).perform

          flash[response.flash_status] = response.flash_message
          render response.view_to_render
        else
          flash[:danger] = "We could not complete this registration. See errors."
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
    when 'new', 'show', 'edit', 'create', 'update'
      'static_views'
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
