class RemoveSubtypeFromRegistration < ActiveRecord::Migration[5.0]
  def change
    remove_column :registrations, :subtype
  end
end
