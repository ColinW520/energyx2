class StudioSessionsController < ApplicationController
  before_filter :find_studio_session, except: [:index, :new, :create, :list]
  skip_before_action :authenticate_user!, :only => [:list, :show]
  layout :resolve_layout

  def index
    studio_sessions_scope = StudioSession.includes(:studio_session_type, :coach).rank(:display_order)
    respond_to do |format|
      format.html {
        smart_listing_create :studio_sessions, studio_sessions_scope, partial: 'studio_sessions/listing', default_sort: { display_order: :asc }
      }
      format.js { smart_listing_create :studio_sessions, studio_sessions_scope, partial: 'studio_sessions/listing', default_sort: { display_order: :asc } }
      format.csv { send_data studio_sessions_scope.to_csv, filename: "studio_sessions_as_of-#{Time.now}.csv" }
    end
  end

  def list
    @days = StudioSession.includes(:studio_session_type, :coach).rank(:display_order).group_by(&:day_of_week)
  end

  def new
    @studio_session = StudioSession.new
  end

  def create
    @studio_session = StudioSession.new(studio_session_params)
    respond_to do |format|
      if @studio_session.save
        format.json { head :no_content }
        format.js { flash[:success] = 'Class has been created.' }
        format.html {
          flash[:success] = 'Class has been created.'
          redirect_to studio_sessions_path
        }
      else
        format.json { render json: @studio_session.errors.full_messages, status: :unprocessable_entity }
      end

    end
  end

  def show
  end

  def edit

  end

  def update
    respond_to do |format|
      if @studio_session.update(studio_session_params)
        format.html {
          flash[:sucess] = 'Class has been updated!'
          redirect_to studio_sessions_path
        }
        format.json { head :no_content }
        format.js { flash[:success] = 'Class has been updated.' }
      else
        format.json { render json: @studio_session.errors.full_messages, status: :unprocessable_entity }
        format.js { render json: @studio_session.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def update_row_order
    @studio_session.display_order_position = params[:display_order_position]
    @studio_session.save!

    head :ok # this is a POST action, updates sent via AJAX, no view rendered
  end

  def destroy
    @studio_session.destroy
    respond_to do |format|
      format.js { flash[:success] = 'Class removed.' }
      format.html { redirect_to studio_sessions_path, notice: 'Class removed.' }
      format.json { head :no_content }
    end
  end

  private

  def resolve_layout
    if action_name == "list"
      nil
    else
      "application"
    end
  end

  def find_studio_session
    @studio_session = StudioSession.find(params[:id])
  end

  def studio_session_params
    params.require(:studio_session).permit!
  end
end
