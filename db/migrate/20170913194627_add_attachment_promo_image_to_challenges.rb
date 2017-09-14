class AddAttachmentPromoImageToChallenges < ActiveRecord::Migration
  def self.up
    change_table :challenges do |t|
      t.attachment :promo_image
    end
  end

  def self.down
    remove_attachment :challenges, :promo_image
  end
end
