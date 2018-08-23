class EventTeam < ApplicationRecord
  belongs_to :event
  has_many :registrations
  serialize :allowed_emails, Array
  before_save :format_emails
  before_save :remove_blank_emails

  def format_emails
    self.allowed_emails.split(',').join
  end

  def remove_blank_emails
    allowed_emails.reject!(&:blank?)
  end
end
