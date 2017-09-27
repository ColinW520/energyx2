class SubmissionsController < ApplicationController
  before_filter :find_submission, except: [:index, :new, :create, :list]
  layout :resolve_layout

  def index
    submissions_scope = Submission.includes(:participant).order(created_at: :desc)
    respond_to do |format|
      format.html { smart_listing_create :submissions, submissions_scope, partial: 'submissions/listing', default_sort: { created_at: :desc }, page_sizes: [100, 200, 300] }
      format.js { smart_listing_create :submissions, submissions_scope, partial: 'submissions/listing', default_sort: { created_at: :desc } }
      format.csv { send_data submissions_scope.to_csv, filename: "submissions_as_of-#{Time.now}.csv" }
    end
  end

  def list
    @submissions = Submission.includes(:participant).order(created_at: :desc)
  end

  def new
    @submission = Submission.new
  end

  def create
    @submission = Submission.new(submission_params)
    respond_to do |format|
      if @submission.save
        format.json { head :no_content }
        format.js { flash[:success] = 'Submission has been created.' }
        format.html {
          flash[:success] = 'Submission has been created.'
          redirect_to submissions_path
        }
      else
        format.json { render json: @submission.errors.full_messages, status: :unprocessable_entity }
      end

    end
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @submission.update(submission_params)
        format.html {
          flash[:sucess] = 'Submission has been updated!'
          redirect_to submissions_path
        }
        format.json { head :no_content }
        format.js { flash[:success] = 'Submission has been updated.' }
      else
        format.json { render json: @submission.errors.full_messages, status: :unprocessable_entity }
        format.js { render json: @submission.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @submission.destroy
    respond_to do |format|
      format.js { flash[:success] = 'Submission has been removed.' }
      format.html { redirect_to submissions_path, notice: 'Submission removed.' }
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

  def find_submission
    @submission = Submission.find(params[:id])
  end

  def submission_params
    params.require(:submission).permit!
  end
end
