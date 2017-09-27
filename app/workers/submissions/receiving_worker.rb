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
          @submission.parse_meters
          # FREQUENCY CHECK RULE
          if @participant.submissions.valid.accepted.with_meters.where(created_at: DateTime.now.in_time_zone(Time.zone).beginning_of_day..Time.now).count > 1
            @submission.is_rejected = true
            @submission.rejection_reason = "Daily Frequency check failed."
            @submission.response_text = "Sorry, you can only submit meters a 2x/day MAX. Please try again tomorrow!"
          # VOLUME CHECK RULE
          elsif @submission.parsed_meters >= 12500
            @submission.is_rejected = true
            @submission.rejection_reason = "Meters exceed class maximum."
            @submission.response_text = "Wow! That's a big number. The maximum for a single submission is 12,500. If this isn't a typo, email us: contact@energyxfitness.com"
          else
            @submission.is_rejected = false
            @submission.response_text = "Got it. Check out your profile! https://energyxfitness.com/participants/#{@participant.id}-#{@participant.mobile_phone.last(4)}"
          end
        when 'link'
          @submission.response_text = "Here is a link to your profile! https://energyxfitness.com/participants/#{@participant.id}-#{@participant.mobile_phone.last(4)}"
        when 'stats'
          @submission.response_text = "All-Time: #{@participant.total_meters}. This Year: #{@participant.meters_from(Time.now.beginning_of_year, Time.now)}. This Month: #{@participant.meters_from(Time.now.beginning_of_month, Time.now)}. This Week: #{@participant.meters_from(Time.now.beginning_of_week, Time.now)}"
        else
          @submission.response_text = "Hi! We don't know what to do with that input. Try 'Meters:' or 'Name: '. Check out https://energyxfitess.com/join"
      end

      # @submission.response_text = "See your stats here: http://energyxfitness.com/participants/#{@participant.id}-#{@participant.mobile_phone.last(4)}"
    end

    @submission.save!
    @participant.save!

    Submissions::RespondingWorker.perform_async(@submission.id, @message.from)
  end
end
