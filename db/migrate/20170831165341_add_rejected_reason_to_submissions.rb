class AddRejectedReasonToSubmissions < ActiveRecord::Migration[5.0]
  def change
    add_column :submissions, :rejection_reason, :string
  end
end
