class StudiosController < ApplicationController
  before_filter :find_studio, except: [:index, :new, :create, :list]
  skip_before_action :authenticate_user!, only: [:list, :show]
  layout :resolve_layout

  def index
    studios_scope = Studio.order(:name)

    respond_to do |format|
      format.html {
        smart_listing_create(
          :studios,
          studios_scope,
          partial: 'studios/listing'
        )
      }
      format.js {
        smart_listing_create(
          :studios,
          studios_scope,
          partial: 'studios/listing',
        )
      }
    end
  end

  def list
    @studios = Studio.order(:name)
  end

  def new
    @studio = Studio.new
  end

  def create
    @studio = Studio.new(studio_params)
    respond_to do |format|
      if @studio.save
        format.json { head :no_content }
        format.js { flash[:success] = 'Studio has been created.' }
        format.html {
          flash[:success] = 'Studio has been created.'
          redirect_to studios_path
        }
      else
        format.json do
          render(
            json: @studio.errors.full_messages, status: :unprocessable_entity
          )
        end
      end

    end
  end

  def show
  end

  def edit

  end

  def update
    respond_to do |format|
      if @studio.update(studio_params)
        format.html {
          flash[:sucess] = 'Studio has been updated!'
          redirect_to studios_path
        }
        format.json { head :no_content }
        format.js { flash[:success] = 'Studio has been updated.' }
      else
        format.json do
          render(
            json: @studio.errors.full_messages, status: :unprocessable_entity
          )
        end
        format.js do
          render(
            json: @studio.errors.full_messages, status: :unprocessable_entity
          )
        end
      end
    end
  end

  def destroy
    @studio.destroy
    respond_to do |format|
      format.js { flash[:success] = 'Studio removed.' }
      format.html { redirect_to studios_path, notice: 'Studio removed.' }
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

  def find_studio
    @studio = Studio.friendly.find(params[:id])
  end

  def studio_params
    params.require(:studio).permit!
  end
end
