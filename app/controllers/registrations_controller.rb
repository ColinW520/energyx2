class RegistrationsController < ApplicationController
  before_filter :find_registration, except: [:index, :new, :create, :list]
  skip_before_action :authenticate_user!, :only => [:list, :show, :new, :create, :edit, :update]
  layout :resolve_layout

  def index
    @event = Event.friendly.find params[:event_id]
    registrations_scope = @event.registrations

    respond_to do |format|
      format.html {
        smart_listing_create :registrations, registrations_scope, partial: 'registrations/listing', default_sort: { created_at: :desc }
      }
      format.js { smart_listing_create :registrations, registrations_scope, partial: 'registrations/listing', default_sort: { created_at: :desc } }
      #format.csv { send_data registrations_scope.to_csv, filename: "registrations_as_of-#{Time.now}.csv" }
    end
  end

  def new
    @event = Event.friendly.find params[:event_id]
    @registration = Registration.new(event_id: @event.id)
    @registration.registration_members.build
    gon.stripe_description = "Registration for #{@event.name}"
  end

  def create
    @event = Event.friendly.find params[:event_id]
    @registration = Registration.new(registration_params)

    respond_to do |format|
      if @registration.save
        @registration.create_charge(params)
        format.html {
          flash[:danger] = 'Registration has been created.'
          redirect_to event_registration_path(@event, @registration)
        }
      else
        format.json { render json: @registration.errors.full_messages, status: :unprocessable_entity }
        format.html {
          flash[:notice] = "There were errors in your submission. Your card has NOT been charged."
          render :new
        }
      end

    end
  end

  def show
  end

  def edit
  end

  def update
    @event = Event.friendly.find params[:event_id]
    respond_to do |format|
      if @registration.update(registration_params)
        format.html {
          flash[:sucess] = 'Registration has been updated!'
          redirect_to event_registration_path(@event, @registration)
        }
        format.json { head :no_content }
        format.js { flash[:success] = 'Registration has been updated.' }
      else
        format.json { render json: @registration.errors.full_messages, status: :unprocessable_entity }
        format.js { render json: @registration.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @registration.destroy
    respond_to do |format|
      format.js { flash[:success] = 'Registration removed.' }
      format.html { redirect_to events_registrations_path, notice: 'Registration removed.' }
      format.json { head :no_content }
    end
  end

  private

  def resolve_layout
    case action_name
      when 'list'
        nil
      when 'new', 'create', 'edit', 'update', 'show'
        "static_views"
      else
        "application"
    end
  end

  def find_registration
    @event = Event.friendly.find params[:event_id]
    @registration = @event.registrations.find params[:id]
  end

  def registration_params
    params.require(:registration).permit!
  end
end
