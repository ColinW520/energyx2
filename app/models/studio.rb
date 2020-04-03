class Studio < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_attached_file :banner_image,
    dependent: :destroy,
    default_url: "https://live.staticflickr.com/1748/27877174107_3f58f36a54_h.jpg"
  validates_attachment_content_type :banner_image, content_type: /\Aimage\/.*\Z/
  validates_attachment(
    :banner_image,
    content_type: { content_type: ['image/jpeg', 'image/gif', 'image/png'] }
  )


  def self.virtual
    self.where(name: 'Virtual').last
  end
end
