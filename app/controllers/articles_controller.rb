class ArticlesController < ApplicationController
  before_action :find_article, except: [:index, :new, :create, :list]
  skip_before_action :authenticate_user!, :only => [:list, :show]
  layout :resolve_layout

  def index
    articles_scope = Article.available

    respond_to do |format|
      format.html {
        smart_listing_create :articles, articles_scope, partial: 'articles/listing', default_sort: { available_at: :asc }
      }
      format.js { smart_listing_create :articles, articles_scope, partial: 'articles/listing', default_sort: { available_at: :asc } }
    end
  end

  def list
    @subnav = 'blog'
    @articles = Article.available.order(available_at: :desc)
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    respond_to do |format|
      if @article.save
        format.json { head :no_content }
        format.js { flash[:success] = 'Article has been created.' }
        format.html {
          flash[:success] = 'Article has been created.'
          redirect_to articles_path
        }
      else
        format.json { render json: @article.errors.full_messages, status: :unprocessable_entity }
      end

    end
  end

  def show
  end

  def edit

  end

  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html {
          flash[:sucess] = 'Article has been updated!'
          redirect_to articles_path
        }
        format.json { head :no_content }
        format.js { flash[:success] = 'Article has been updated.' }
      else
        format.json { render json: @article.errors.full_messages, status: :unprocessable_entity }
        format.js { render json: @article.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @article.destroy
    respond_to do |format|
      format.js { flash[:success] = 'Article removed.' }
      format.html { redirect_to articles_path, notice: 'Article removed.' }
      format.json { head :no_content }
    end
  end

  private

  def resolve_layout
    case action_name
    when "list"
      'static_views'
    when 'show'
      'static_views'
    else
      "application"
    end
  end

  def find_article
    @article = Article.friendly.find(params[:id])
  end

  def article_params
    params.require(:article).permit!
  end
end
