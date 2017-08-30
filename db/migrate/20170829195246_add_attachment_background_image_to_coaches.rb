class AddAttachmentBackgroundImageToCoaches < ActiveRecord::Migration
  def self.up
    change_table :coaches do |t|
      t.attachment :background_image
    end
  end

  def self.down
    remove_attachment :coaches, :background_image
  end
end
