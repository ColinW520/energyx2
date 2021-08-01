class CoachesController < ApplicationController
  before_action :find_coach, except: [:index, :new, :create, :list]
  skip_before_action :authenticate_user!, :only => [:list, :show]
  layout :resolve_layout

  def index
    coaches_scope = Coach.rank(:display_order)

    respond_to do |format|
      format.html {
        smart_listing_create :coaches, coaches_scope, partial: 'coaches/listing', default_sort: { display_order: :asc }
      }
      format.js { smart_listing_create :coaches, coaches_scope, partial: 'coaches/listing', default_sort: { display_order: :asc } }
      format.csv { send_data coaches_scope.to_csv, filename: "coaches_as_of-#{Time.now}.csv" }
    end
  end

  def list
    @coaches = Coach.rank(:display_order)
  end

  def new
    @coach = Coach.new
  end

  def create
    @coach = Coach.new(coach_params)
    respond_to do |format|
      if @coach.save
        format.json { head :no_content }
        format.js { flash[:success] = 'Coach has been created.' }
        format.html {
          flash[:success] = 'Coach has been created.'
          redirect_to coaches_path
        }
      else
        format.json { render json: @coach.errors.full_messages, status: :unprocessable_entity }
      end

    end
  end

  def show
  end

  def edit

  end

  def update
    respond_to do |format|
      if @coach.update(coach_params)
        format.html {
          flash[:sucess] = 'Coach has been updated!'
          redirect_to coaches_path
        }
        format.json { head :no_content }
        format.js { flash[:success] = 'Coach has been updated.' }
      else
        format.json { render json: @coach.errors.full_messages, status: :unprocessable_entity }
        format.js { render json: @coach.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def update_row_order
    @coach.display_order_position = params[:display_order_position]
    @coach.save!

    head :ok # this is a POST action, updates sent via AJAX, no view rendered
  end

  def destroy
    @coach.destroy
    respond_to do |format|
      format.js { flash[:success] = 'Coach removed.' }
      format.html { redirect_to coaches_path, notice: 'Coach removed.' }
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

  def find_coach
    @coach = Coach.find(params[:id])
  end

  def coach_params
    params.require(:coach).permit!
  end
end
