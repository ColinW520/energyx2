class ParticipantsController < ApplicationController
  before_filter :find_participant, except: [:index, :new, :create, :list]
  layout :resolve_layout

  def index
    participants_scope = Participant.includes(:submissions).order(name: :asc)
    respond_to do |format|
      format.html {
        smart_listing_create :participants, participants_scope, partial: 'participants/listing', default_sort: { name: :asc }
      }
      format.js { smart_listing_create :participants, participants_scope, partial: 'participants/listing', default_sort: { name: :asc } }
      format.csv { send_data participants_scope.to_csv, filename: "participants_as_of-#{Time.now}.csv" }
    end
  end

  def list
    @participants = Participant.includes(:submissions).order(name: :asc)
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
    if action_name == "list"
      nil
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
