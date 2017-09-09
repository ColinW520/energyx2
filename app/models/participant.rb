class Participant < ApplicationRecord
  has_many :submissions, dependent: :destroy
  scope :visible, -> { where.not(name: nil) }
  scope :all_time_leaders, -> { joins(:submissions).select('participants.*, sum(submissions.parsed_meters) as the_meters').group('participants.id').order('the_meters DESC') }
  scope :time_frame_leaders, ->(start, finish) { joins(:submissions).where(submissions: { created_at: start..finish }).select('participants.*, sum(submissions.parsed_meters) as the_meters').group('participants.id').order('the_meters DESC') }

  phony_normalize :mobile_phone, default_country_code: 'US'
  validates :mobile_phone,
            presence: true,
            phony_plausible: true

  def total_meters
    self.submissions.valid.accepted.sum(:parsed_meters)
  end

  def meters_from(the_start, the_end)
    self.submissions.valid.accepted.where(created_at: the_start..the_end).sum(:parsed_meters)
  end

  def to_param
    [name.parameterize, id].join("-")
  end
end
