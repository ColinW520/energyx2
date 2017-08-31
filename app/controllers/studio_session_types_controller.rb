class StudioSessionTypesController < ApplicationController
  before_filter :find_studio_session_type, except: [:index, :new, :create, :list]
  skip_before_action :authenticate_user!, :only => [:list, :show]
  layout :resolve_layout

  def index
    studio_session_types_scope = StudioSessionType.rank(:display_order)

    respond_to do |format|
      format.html {
        smart_listing_create :studio_session_types, studio_session_types_scope, partial: 'studio_session_types/listing', default_sort: { display_order: :asc }
      }
      format.js { smart_listing_create :studio_session_types, studio_session_types_scope, partial: 'studio_session_types/listing', default_sort: { display_order: :asc } }
      format.csv { send_data studio_session_types_scope.to_csv, filename: "studio_session_types_as_of-#{Time.now}.csv" }
    end
  end

  def list
    @types = StudioSessionType.rank(:display_order)
  end

  def new
    @studio_session_type = StudioSessionType.new
  end

  def create
    @studio_session_type = StudioSessionType.new(studio_session_type_params.except(:tag_list))
    @studio_session_type.tag_list = params[:studio_session_type][:tag_list]

    respond_to do |format|
      if @studio_session_type.save
        format.json { head :no_content }
        format.js { flash[:success] = "#{@studio_session_type.name} has been created. You can now add classes with this type." }
        format.html {
          flash[:success] = 'Clas Type has been created.'
          redirect_to studio_session_types_path
        }
      else
        format.json { render json: @studio_session_type.errors.full_messages, status: :unprocessable_entity }
      end

    end
  end

  def show
  end

  def edit

  end

  def update
    @studio_session_type.tag_list = params[:studio_session_type][:tag_list]

    respond_to do |format|
      if @studio_session_type.update(studio_session_type_params.except(:tag_list))
        format.html {
          flash[:sucess] = 'StudioSessionType has been updated!'
          redirect_to studio_session_types_path
        }
        format.json { head :no_content }
        format.js { flash[:success] = 'StudioSessionType has been updated.' }
      else
        format.json { render json: @studio_session_type.errors.full_messages, status: :unprocessable_entity }
        format.js { render json: @studio_session_type.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @studio_session_type.destroy
    respond_to do |format|
      format.js { flash[:success] = 'Class Type removed. All of its classes have also been removed.' }
      format.html { redirect_to studio_session_types_path, notice: 'Class Type removed.' }
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

  def find_studio_session_type
    @studio_session_type = StudioSessionType.find(params[:id])
    gon.studio_session_type_id = @studio_session_type.id
  end

  def studio_session_type_params
    params.require(:studio_session_type).permit!
  end
end
