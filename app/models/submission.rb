class Submission < ApplicationRecord
  belongs_to :participant, counter_cache: true

  validates :participant, presence: true
  validates :twilio_sid, presence: true

  scope :valid, -> { where(is_valid: true) }
  scope :accepted, -> { where(is_rejected: false) }
  scope :with_meters, -> { where('parsed_meters IS NOT NULL').where('parsed_meters > 0') }

  def set_validity
    if self.message_body.include?("meters:") && self.message_body.include?("name:")
      self.is_valid = false
      self.response_text = "Hi! We love the enthusiam, but we can only handle one thing at a time. Please try either 'Name: Your Name' OR 'Meters: Your Meters'."
    end

    unless ['name:', 'meters:', 'link', 'stats'].include? self.body.partition(":").first.squish.downcase
      self.is_valid = false
      self.response_text = "Hi! We don't know what to do with that input. Check out the guide here: http://energyxfitness.com/help"
    end

    self.is_valid = true
  end

  def parse_meters
    self.parsed_meters = self.message_body.partition(":").last.squish.gsub(/[^0-9a-z ]/i, '').to_i
  end

  def parse_name
    self.parsed_name = self.message_body.partition(":").last.squish
  end
end
