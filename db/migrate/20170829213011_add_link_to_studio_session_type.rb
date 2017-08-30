class AddLinkToStudioSessionType < ActiveRecord::Migration[5.0]
  def change
    add_column :studio_session_types, :link, :string
  end
end
