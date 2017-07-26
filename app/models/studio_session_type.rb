class StudioSessionType < ApplicationRecord
  belongs_to: :organization
  acts_as_taggable_on :tags

  def self.filter_by(params)
    params = params.with_indifferent_access
    scope = self.includes(:organization, :studio_sessions)
    scope = self.where(organization_id: params[:organization_id]) if params[:organization_id].present?
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
