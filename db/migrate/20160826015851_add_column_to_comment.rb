class AddColumnToComment < ActiveRecord::Migration[5.0]
  def change
  	add_column :comments, :description, :string
  	add_column :comments, :user_id, :integer
  end
end