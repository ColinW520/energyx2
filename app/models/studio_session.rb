class StudioSession < ApplicationRecord
  belongs_to :coach
  belongs_to :studio_session_type

  include RankedModel
  ranks :display_order

  def self.to_csv
    attributes = self.column_names

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |t|
        csv << attributes.map { |attr| t.send(attr) }
      end
    end
  end
end
