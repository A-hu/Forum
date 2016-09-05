class AddPublicIntoComments < ActiveRecord::Migration[5.0]
  def change
  	add_column :comments, :is_public, :boolean
  end
end
