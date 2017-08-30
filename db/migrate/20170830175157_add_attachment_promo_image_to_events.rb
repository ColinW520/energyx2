class AddAttachmentPromoImageToEvents < ActiveRecord::Migration
  def self.up
    change_table :events do |t|
      t.attachment :promo_image
    end
  end

  def self.down
    remove_attachment :events, :promo_image
  end
end
