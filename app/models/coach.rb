class Coach < ApplicationRecord
  acts_as_taggable_on :tags
  validates :name, presence: true

  has_attached_file :profile_image,
    styles: {
      thumb: '200x250#',
    },
    dependent: :destroy,
    default_url: "https://farm1.staticflickr.com/891/40935569930_45b4315e48_t.jpg"
  validates_attachment_content_type :profile_image, content_type: /\Aimage\/.*\Z/
  validates_attachment :profile_image, content_type: { content_type: ['image/jpeg', 'image/gif', 'image/png'] }


  include RankedModel
  ranks :display_order

  def self.to_csv
    attributes = self.column_names
    attributes << 'tags'

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |t|
        csv << attributes.map { |attr| attr == 'tags' ? t.tags.pluck(:name).split(',').join('|') : t.send(attr) }
      end
    end
  end
end
