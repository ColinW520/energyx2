class RegistrationsController < ApplicationController
  before_filter :set_event
  skip_before_action :authenticate_user!, :only => [:show, :new, :create, :edit, :update]
  layout :resolve_layout

  def index
    registrations_scope = @event.registrations

    respond_to do |format|
      format.html do
        smart_listing_create(
          :registrations,
          registrations_scope,
          partial: 'registrations/listing',
          default_sort: { created_at: :desc },
          page_sizes: [50, 100, 150]
        )
      end
      format.js do
        smart_listing_create(
          :registrations,
          registrations_scope,
          partial: 'registrations/listing',
          default_sort: { created_at: :desc }
        )
      end
      format.csv do
        send_data(
          registrations_scope.to_csv,
          filename: "registrations_as_of-#{Time.now}.csv"
        )
      end
    end
  end

  def new
    @registration = Registration.new(event_id: @event.id)
    gon.stripe_description = "ENERGYX #{@event.name}"
  end

  def create
    @registration = Registration.new(registration_params)

    respond_to do |format|
      if @registration.save
        if @registration.event_stage.present?
          @registration.event_stage.increment!(:registrations_count)
        end
        @registration.create_charge(params) unless @event.is_free?
        ConfirmationMailer.event_solo_registration(@registration.id).deliver
        format.html do
          flash[:danger] = 'Your Registration has been created!'
          redirect_to event_registration_path(
            @event,
            @registration,
            email_check: @registration.email
          )
        end
      else
        format.html do
          flash[:notice] = "There were errors in your submission." +
            "Your card has NOT been charged."
          render :new
        end
      end

    end
  end

  def show
  end

  def edit
    find_registration
  end

  def update
    find_registration

    respond_to do |format|
      if @registration.update(registration_params)
        format.html {
          flash[:sucess] = 'Registration has been updated!'
          redirect_to event_registrations_path
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
    if @registation.event_stage.present?
      @registration.event_stage.registrations_count.decrement!
    end
    respond_to do |format|
      format.js { flash[:success] = 'Registration removed.' }
      format.html do
        redirect_to events_registrations_path, notice: 'Registration removed.'
      end
      format.json { head :no_content }
    end
  end

  private

  def resolve_layout
    case action_name
    when "list"
      nil
    when 'new', 'show', 'edit'
      'static_views'
    else
      "application"
    end
  end

  def set_event
    @event = Event.friendly.find params[:event_id]
  end

  def find_registration
    @registration = @event.registrations.find params[:id]
  end

  def registration_params
    params.require(:registration).permit!
  end
end
