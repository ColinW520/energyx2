class QuestionsController < ApplicationController
  before_action :find_question, except: [:index, :new, :create, :list]
  skip_before_action :authenticate_user!, :only => [:list, :show]
  layout :resolve_layout

  def index
    questions_scope = Question.rank(:display_order).all

    respond_to do |format|
      format.html {
        smart_listing_create :questions, questions_scope, partial: 'questions/listing', default_sort: { display_order: :asc }
      }
      format.js { smart_listing_create :questions, questions_scope, partial: 'questions/listing', default_sort: { display_order: :asc } }
      format.csv { send_data questions_scope.to_csv, filename: "questions_as_of-#{Time.now}.csv" }
    end
  end

  def list
    @questions = Question.rank(:display_order).all
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    respond_to do |format|
      if @question.save
        format.json { head :no_content }
        format.js { flash[:success] = 'Question has been created.' }
        format.html {
          flash[:success] = 'Question has been created.'
          redirect_to questions_path
        }
      else
        format.json { render json: @question.errors.full_messages, status: :unprocessable_entity }
      end

    end
  end

  def show
  end

  def edit

  end

  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html {
          flash[:sucess] = 'Question has been updated!'
          redirect_to questions_path
        }
        format.json { head :no_content }
        format.js { flash[:success] = 'Question has been updated.' }
      else
        format.json { render json: @question.errors.full_messages, status: :unprocessable_entity }
        format.js { render json: @question.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def update_row_order
    @question.display_order_position = params[:display_order_position]
    @question.save!

    head :ok # this is a POST action, updates sent via AJAX, no view rendered
  end

  def destroy
    @question.destroy
    respond_to do |format|
      format.js { flash[:success] = 'Question removed.' }
      format.html { redirect_to questions_path, notice: 'Question removed.' }
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

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit!
  end
end
