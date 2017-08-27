class StudioSessionTypesController < ApplicationController
  before_filter :find_studio_session_type, except: [:index, :new, :create]

  def index
    studio_session_types_scope = StudioSessionType.all

    respond_to do |format|
      format.html {
        smart_listing_create :studio_session_types, studio_session_types_scope, partial: 'studio_session_types/listing', default_sort: { display_order: :asc }
      }
      format.js { smart_listing_create :studio_session_types, studio_session_types_scope, partial: 'studio_session_types/listing', default_sort: { display_order: :asc } }
      format.csv { send_data studio_session_types_scope.to_csv, filename: "studio_session_types_as_of-#{Time.now}.csv" }
    end
  end

  def new
    @studio_session_type = StudioSessionType.new(organization_id: current_user.organization_id)
  end

  def create
    @studio_session_type = StudioSessionType.create(studio_session_type_params.except(:tag_list))
    @studio_session_type.tag_list = params[:studio_session_type][:tag_list]

    respond_to do |format|
      if @studio_session_type.save
        format.json { head :no_content }
        format.js { flash[:success] = 'Class Type has been created.' }
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
      format.js { flash[:success] = 'StudioSessionType removed.' }
      format.html { redirect_to studio_session_types_path, notice: 'Class Type removed.' }
      format.json { head :no_content }
    end
  end

  private

  def find_studio_session_type
    @studio_session_type = StudioSessionType.find(params[:id])
    gon.studio_session_type_id = @studio_session_type.id
  end

  def studio_session_type_params
    params.require(:studio_session_type).permit!
  end
end
