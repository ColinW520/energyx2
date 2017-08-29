class CoachesController < ApplicationController
  before_filter :find_coach, except: [:index, :new, :create]

  def index
    coachs_scope = Coach.rank(:display_order)

    respond_to do |format|
      format.html {
        smart_listing_create :coaches, coachs_scope, partial: 'coaches/listing', default_sort: { display_order: :asc }
      }
      format.js { smart_listing_create :coaches, coachs_scope, partial: 'coaches/listing', default_sort: { display_order: :asc } }
      format.csv { send_data coaches_scope.to_csv, filename: "coaches_as_of-#{Time.now}.csv" }
    end
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
          flash[:success] = 'Clas has been created.'
          redirect_to coachs_path
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
          redirect_to coachs_path
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
      format.html { redirect_to coachs_path, notice: 'Coach removed.' }
      format.json { head :no_content }
    end
  end

  private

  def find_coach
    @coach = Coach.find(params[:id])
  end

  def coach_params
    params.require(:coach).permit!
  end
end
