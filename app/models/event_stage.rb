class EventStage < ApplicationRecord
  belongs_to :event
  has_many :registrations

  scope :available, -> { where('registrations_count < cap_size') }

  def sold_out?
    self.registrations_count >= self.cap_size
  end
end
