class ApplicationController < ActionController::Base
  include AmazonSignature
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper
  protect_from_forgery with: :exception, prepend: true

  before_action :authenticate_user!, :set_xhr_flag, :send_env_js, :set_subnav
  after_action :prepare_unobtrusive_flash
  layout -> (controller) { controller.request.xhr? ? false : 'application' }

  def after_sign_in_path_for(resource)
    events_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  protected

  def send_env_js
    gon.user_id = current_user.try(:id) if current_user.present?
    gon.rails_environment = Rails.env
    gon.froala_key = ENV['FROALA_KEY']
    gon.aws_bucket = ENV['S3_BUCKET_NAME']
    gon.aws_region = ENV['S3_REGION']
    gon.aws_hash = AmazonSignature::data_hash
    gon.stripe_publishable_key = ENV['STRIPE_PUBLISHABLE_KEY']
  end

  def set_xhr_flag
    @xhr = request.xhr?
  end

  def set_subnav
    @subnav = controller_name
  end

  def configure_permitted_parameters
   devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :organization_id])
  end
end
