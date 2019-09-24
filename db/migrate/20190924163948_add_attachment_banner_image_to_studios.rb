class AddAttachmentBannerImageToStudios < ActiveRecord::Migration
  def self.up
    change_table :studios do |t|
      t.attachment :banner_image
    end
  end

  def self.down
    remove_attachment :studios, :banner_image
  end
end
