class Twilio::BaseController < ActionController::Base
  before_action :set_client

  require 'twilio-ruby'
  layout false

  def set_client
    @twilio_client = Twilio::REST::Client.new(ENV['TWILIO_COLIN_SID'], ENV['TWILIO_COLIN_AUTH_TOKEN'])
  end
end
