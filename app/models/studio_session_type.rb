class StudioSessionType < ApplicationRecord
  include RankedModel
  ranks :display_order

  acts_as_taggable_on :tags

  has_attached_file :promo_image,
    styles: {
      thumb: '200x250#',
      display: '480x640#'
    },
    dependent: :destroy,
    default_url: "https://farm1.staticflickr.com/891/40935569930_45b4315e48_t.jpg"
  validates_attachment_content_type :promo_image, content_type: /\Aimage\/.*\Z/
  validates_attachment :promo_image, content_type: { content_type: ['image/jpeg', 'image/gif', 'image/png'] }

  def self.filter_by(params)
    params = params.with_indifferent_access
    scope = self.includes(:studio_sessions)
    scope = scope.tagged_with(params[:tags]) if params[:tags].present?
    return scope
  end

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
