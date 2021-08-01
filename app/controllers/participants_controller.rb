class ParticipantsController < ApplicationController
  before_action :find_participant, except: [:index, :new, :create, :list]
  skip_before_action :authenticate_user!, :only => [:list, :show]
  layout :resolve_layout

  def index
    participants_scope = Participant.includes(:submissions)
    respond_to do |format|
      format.html { smart_listing_create :participants, participants_scope, partial: 'participants/listing', default_sort: { created_at: :desc }, page_sizes: [100, 200, 300] }
      format.js { smart_listing_create :participants, participants_scope, partial: 'participants/listing', default_sort: { created_at: :desc }, page_sizes: [100, 200, 300] }
      format.csv { send_data participants_scope.to_csv, filename: "participants_as_of-#{Time.now}.csv" }
    end
  end

  def list
    @all_time_leaders = Participant.all_time_leaders.limit(10)
    @week_leaders = Participant.time_frame_leaders(Time.now.beginning_of_week, Time.now).limit(10)
  end

  def new
    @participant = Participant.new
  end

  def create
    @participant = Participant.new(participant_params)
    respond_to do |format|
      if @participant.save
        format.json { head :no_content }
        format.js { flash[:success] = 'Participant has been created.' }
        format.html {
          flash[:success] = 'Participant has been created.'
          redirect_to participants_path
        }
      else
        format.json { render json: @participant.errors.full_messages, status: :unprocessable_entity }
      end

    end
  end

  def show
    @submissions = @participant.submissions.valid.with_meters.accepted
  end

  def edit
  end

  def update
    respond_to do |format|
      if @participant.update(participant_params)
        format.html {
          flash[:sucess] = 'Participant has been updated!'
          redirect_to participants_path
        }
        format.json { head :no_content }
        format.js { flash[:success] = 'Participant has been updated.' }
      else
        format.json { render json: @participant.errors.full_messages, status: :unprocessable_entity }
        format.js { render json: @participant.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @participant.destroy
    respond_to do |format|
      format.js { flash[:success] = 'Participant has been removed.' }
      format.html { redirect_to participants_path, notice: 'Participant removed.' }
      format.json { head :no_content }
    end
  end

  private

  def resolve_layout
    case action_name
      when "list"
        nil
      when "show"
        "static_views"
      else
        "application"
    end
  end

  def find_participant
    @participant = Participant.find(params[:id])
  end

  def participant_params
    params.require(:participant).permit!
  end
end
