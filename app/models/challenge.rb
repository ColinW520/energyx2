class Challenge < ApplicationRecord
  scope :upcoming, -> { where("starts_at > NOW()").order(starts_at: :asc) }
  scope :active, -> { where("starts_at < NOW() AND ends_at > NOW()").order(starts_at: :asc) }

  has_attached_file :promo_image,
    styles: {
      thumb: '250x200#',
    },
    dependent: :destroy,
    default_url: "https://farm1.staticflickr.com/891/40935569930_45b4315e48_t.jpg"
  validates_attachment_content_type :promo_image, content_type: /\Aimage\/.*\Z/
  validates_attachment :promo_image, content_type: { content_type: ['image/jpeg', 'image/gif', 'image/png'] }

  def participants
    # this needs to return an array.
    Participant.visible.active.joins(:submissions).
                where(submissions: { created_at: self.starts_at..self.ends_at }).
                where("submissions.parsed_meters IS NOT NULL").
                where("submissions.parsed_meters > 0").
                group('participants.name').
                sum("submissions.parsed_meters").
                sort_by(&:last).reverse.
                first(10)
  end
end
