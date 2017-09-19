class Submissions::RespondingWorker
  include Sidekiq::Worker
  # we don't ever, ever, ever want to double-send
  sidekiq_options retry: false

  def perform(submission_id, from_number)
    @twilio_client = Twilio::REST::Client.new(ENV['TWILIO_COLIN_SID'], ENV['TWILIO_COLIN_AUTH_TOKEN'])
    @submission = Submission.find submission_id

    recipient_hash = { from: ENV['TWILIO_NUMBER'], body: @submission.response_text }
    recipient_hash[:to] = from_number
    @twilio_client.messages.create(recipient_hash)
  end
end
