class PricingOptionsController < ApplicationController
  before_filter :find_pricing_option, except: [:index, :new, :create, :list]
  skip_before_action :authenticate_user!, :only => [:list, :show]
  layout :resolve_layout

  def index
    pricing_options_scope = PricingOption.rank(:display_order)

    respond_to do |format|
      format.html {
        smart_listing_create :pricing_options, pricing_options_scope, partial: 'pricing_options/listing', default_sort: { display_order: :asc }
      }
      format.js { smart_listing_create :pricing_options, pricing_options_scope, partial: 'pricing_options/listing', default_sort: { display_order: :asc } }
    end
  end

  def list
    @pass_options = PricingOption.passes.rank(:display_order)
    @plan_options = PricingOption.plans.rank(:display_order)
  end

  def new
    @pricing_option = PricingOption.new
  end

  def create
    @pricing_option = PricingOption.new(pricing_option_params)
    respond_to do |format|
      if @pricing_option.save
        format.json { head :no_content }
        format.js { flash[:success] = 'Pricing Option has been created.' }
        format.html {
          flash[:success] = 'Clas has been created.'
          redirect_to pricing_options_path
        }
      else
        format.json { render json: @pricing_option.errors.full_messages, status: :unprocessable_entity }
      end

    end
  end

  def show
  end

  def edit

  end

  def update
    respond_to do |format|
      if @pricing_option.update(pricing_option_params)
        format.html {
          flash[:sucess] = 'Pricing Option has been updated!'
          redirect_to pricing_options_path
        }
        format.json { head :no_content }
        format.js { flash[:success] = 'Pricing Option has been updated.' }
      else
        format.json { render json: @pricing_option.errors.full_messages, status: :unprocessable_entity }
        format.js { render json: @pricing_option.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def update_row_order
    @pricing_option.display_order_position = params[:display_order_position]
    @pricing_option.save!

    head :ok # this is a POST action, updates sent via AJAX, no view rendered
  end

  def destroy
    @pricing_option.destroy
    respond_to do |format|
      format.js { flash[:success] = 'Pricing Option removed.' }
      format.html { redirect_to pricing_options_path, notice: 'Pricing Option removed.' }
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

  def find_pricing_option
    @pricing_option = PricingOption.find(params[:id])
  end

  def pricing_option_params
    params.require(:pricing_option).permit!
  end
end
