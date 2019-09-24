class AddMindbodyLinkToStudios < ActiveRecord::Migration[5.0]
  def change
    add_column :studios, :mindbody_link, :string
    add_column :studios, :schedule_widget_id, :string
  end
end
