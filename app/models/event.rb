class Event < ApplicationRecord
  scope :upcoming, -> { where("starts_at > NOW() - INTERVAL '1 DAY' ").order(starts_at: :asc) }
  has_many :registrations, dependent: :destroy
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :event_stages, dependent: :destroy
  accepts_nested_attributes_for :event_stages, allow_destroy: true
  alias waves event_stages

  has_many :event_teams, dependent: :destroy
  accepts_nested_attributes_for :event_teams, allow_destroy: true
  alias teams event_teams

  has_many :event_discount_codes, dependent: :destroy
  accepts_nested_attributes_for :event_discount_codes, allow_destroy: true
  alias discount_codes event_discount_codes

  def open_for_registration?
    has_room? && registerable?
  end

  def has_room?
    if self.waves.any?
      self.waves.sum(:cap_size) >= self.waves.sum(:registrations_count)
    else
      self.cap_size.to_i >= self.registrations.count
    end
  end

  has_attached_file :promo_image,
    s3_protocol: :https,
    styles: {
      thumb: '250x200#',
    },
    dependent: :destroy,
    default_url: "https://res.cloudinary.com/closebrace/image/upload/w_400/v1491315007/usericon_id76rb.png"
  validates_attachment_content_type :promo_image, content_type: /\Aimage\/.*\Z/
  validates_attachment :promo_image, content_type: { content_type: ['image/jpeg', 'image/gif', 'image/png'] }
end
