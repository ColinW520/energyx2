class Coach < ApplicationRecord
  acts_as_taggable_on :tags
  validates :name, presence: true

  has_many :studio_sessions

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
