class Event < ApplicationRecord
  scope :upcoming, -> { where("starts_at > NOW() - INTERVAL '1 DAY' ").order(starts_at: :asc) }
  has_many :registrations, dependent: :destroy
  extend FriendlyId
  friendly_id :name, use: :slugged

  def open_for_registration?
    self.cap_size.to_i >= self.registrations.count
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
