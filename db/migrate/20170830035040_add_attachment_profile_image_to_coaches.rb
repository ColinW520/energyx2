class AddAttachmentProfileImageToCoaches < ActiveRecord::Migration
  def self.up
    change_table :coaches do |t|
      t.attachment :profile_image
    end
  end

  def self.down
    remove_attachment :coaches, :profile_image
  end
end
