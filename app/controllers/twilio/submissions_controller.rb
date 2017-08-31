class Twilio::SubmissionsController < Twilio::BaseController
  def create
    Submissions::ReceivingWorker.perform_async(params['MessageSid']) if Rails.env.production?
    Submissions::ReceivingWorker.new.perform(params['MessageSid']) if Rails.env.development?
  end
end
