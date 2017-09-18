class Challenge < ApplicationRecord
  scope :upcoming, -> { where("starts_at > NOW() - INTERVAL '1 DAY' ").order(starts_at: :asc) }
  scope :active, -> { where("starts_at < NOW() AND ends_at > NOW()").order(starts_at: :asc) }

  has_attached_file :promo_image,
    styles: {
      thumb: '250x200#',
    },
    dependent: :destroy,
    default_url: "http://joappdeals.com/in/wp-content/themes/joapp/images/happyuser/default_user.png"
  validates_attachment_content_type :promo_image, content_type: /\Aimage\/.*\Z/
  validates_attachment :promo_image, content_type: { content_type: ['image/jpeg', 'image/gif', 'image/png'] }

  def participants
    Participant.joins(:submissions).
                where(submissions: { created_at: self.starts_at..self.ends_at }).
                where("submissions.parsed_meters IS NOT NULL").
                where("submissions.parsed_meters > 0").
                group('participants.name').
                sum("submissions.parsed_meters").
                first(10)
      # this needs to return an array.
  end
end
