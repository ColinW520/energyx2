class UsersController < ApplicationController
  before_action :find_user, except: [:index, :new, :create]

  def index
    users_scope = User.all
    smart_listing_create :users,
                         users_scope,
                         partial: "users/listing",
                         default_sort: { created_at: "desc" }
  end

  def show
  end

  def edit

  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html {
          flash[:sucess] = 'User has been updated!'
          redirect_to users_path
        }
        format.json { head :no_content }
        format.js { flash[:success] = 'User has been updated.' }
      else
        format.json { render json: @user.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.soft_delete!
    respond_to do |format|
      format.js { flash[:success] = 'User removed and can no longer access account.' }
      format.html { redirect_to users_path, notice: 'User removed.' }
      format.json { head :no_content }
    end
  end

  def restore

  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit!
  end
end
