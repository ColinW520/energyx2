class ChallengesController < ApplicationController
  before_filter :find_challenge, except: [:index, :new, :create, :list]
  skip_before_action :authenticate_user!, :only => [:list, :show]
  layout :resolve_layout

  def index
    challenges_scope = Challenge.all

    respond_to do |format|
      format.html {
        smart_listing_create :challenges, challenges_scope, partial: 'challenges/listing', default_sort: { starts_at: :asc }
      }
      format.js { smart_listing_create :challenges, challenges_scope, partial: 'challenges/listing', default_sort: { starts_at: :asc } }
      format.csv { send_data challenges_scope.to_csv, filename: "challenges_as_of-#{Time.now}.csv" }
    end
  end

  def list
    @challenges = Challenge.active
  end

  def new
    @challenge = Challenge.new
  end

  def create
    @challenge = Challenge.new(challenge_params)
    respond_to do |format|
      if @challenge.save
        format.json { head :no_content }
        format.js { flash[:success] = 'Challenge has been created.' }
        format.html {
          flash[:success] = 'Challenge has been created.'
          redirect_to challenges_path
        }
      else
        format.json { render json: @challenge.errors.full_messages, status: :unprocessable_entity }
      end

    end
  end

  def show
  end

  def edit

  end

  def update
    respond_to do |format|
      if @challenge.update(challenge_params)
        format.html {
          flash[:sucess] = 'Challenge has been updated!'
          redirect_to challenges_path
        }
        format.json { head :no_content }
        format.js { flash[:success] = 'Challenge has been updated.' }
      else
        format.json { render json: @challenge.errors.full_messages, status: :unprocessable_entity }
        format.js { render json: @challenge.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @challenge.destroy
    respond_to do |format|
      format.js { flash[:success] = 'Challenge removed.' }
      format.html { redirect_to challenges_path, notice: 'Challenge removed.' }
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

  def find_challenge
    @challenge = Challenge.find(params[:id])
  end

  def challenge_params
    params.require(:challenge).permit!
  end
end
