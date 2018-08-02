class Article < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  scope :available, -> { where('available_at < NOW()').order(available_at: :desc) }

  has_attached_file :hero_image,
    s3_protocol: :https,
    styles: {
      thumb: '250x200#',
    },
    dependent: :destroy,
    default_url: "https://farm2.staticflickr.com/1542/26216608485_a83e235a9f_o.png"
  validates_attachment_content_type :hero_image, content_type: /\Aimage\/.*\Z/
  validates_attachment :hero_image, content_type: { content_type: ['image/jpeg', 'image/gif', 'image/png'] }

  def author_name
    User.find(author).try(:full_name)
  end
end
