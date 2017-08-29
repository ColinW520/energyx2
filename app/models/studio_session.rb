class StudioSession < ApplicationRecord
  belongs_to :coach
  belongs_to :studio_session_type

  include RankedModel
  ranks :display_order

  def self.filter_by(params)
    params = params.with_indifferent_access
    scope = self.includes(:studio_session, :coach)
    scope = self.where(studio_session_type_id: params[:type_id]) if params[:type_id]
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
