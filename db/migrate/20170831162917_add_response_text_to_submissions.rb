class AddResponseTextToSubmissions < ActiveRecord::Migration[5.0]
  def change
    add_column :submissions, :response_text, :string
  end
end
