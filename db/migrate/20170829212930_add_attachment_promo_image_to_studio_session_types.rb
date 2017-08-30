class AddAttachmentPromoImageToStudioSessionTypes < ActiveRecord::Migration
  def self.up
    change_table :studio_session_types do |t|
      t.attachment :promo_image
    end
  end

  def self.down
    remove_attachment :studio_session_types, :promo_image
  end
end
