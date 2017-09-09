class Submissions::ReceivingWorker
  include Sidekiq::Worker

  def perform(message_sid)
    @twilio_client = Twilio::REST::Client.new(ENV['TWILIO_COLIN_SID'], ENV['TWILIO_COLIN_AUTH_TOKEN'])
    @message = @twilio_client.messages.get message_sid
    submission_type = @message.body.partition(":").first.squish.downcase

    # it all starts with a participant
    @participant = Participant.where(mobile_phone: @message.from).first_or_create

    # now init a submission
    @submission = Submission.where(twilio_sid: message_sid).first_or_initialize
    @submission.participant_id = @participant.id
    @submission.from_number = @message.from
    @submission.message_body = @message.body
    @submission.set_validity

    if @submission.is_valid?
      case submission_type
        when 'name'
          @participant.update_attribute(:name, @submission.parse_name)
          @submission.response_text = "Name updated to: #{@participant.name}! "
        when 'meters'
          # FREQUENCY CHECK RULE
          @submission.parse_meters
          if @participant.submissions.valid.accepted.with_meters.where(created_at: DateTime.now.in_time_zone(Time.zone).beginning_of_day..Time.now).present?
            @submission.is_rejected = true
            @submission.rejection_reason = "Daily Frequency check failed."
            @submission.response_text = "Sorry, you can only submit your meters once a day. Please try again tomorrow! "
          else
            @submission.is_rejected = false
            @submission.response_text = "Got it! "
          end
        when 'link'

        when 'stats'

        else
          @submission.response_text += "Hi! We don't know what to do with that input."
      end

      @submission.response_text += "See your stats here: http://energyxfitness.com/participants/#{@participant.mobile_phone.last(4)}-#{@participant.id}"
    end

    @submission.save!

    # now reply to the participant
    recipient_hash = { from: ENV['TWILIO_NUMBER'], body: @submission.response_text }
    recipient_hash[:to] = @message.from
    @twilio_client.messages.create(recipient_hash)
  end
end
