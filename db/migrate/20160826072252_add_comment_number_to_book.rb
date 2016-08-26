class AddCommentNumberToBook < ActiveRecord::Migration[5.0]
  def change
  	add_column :books, :comment_number, :integer
  end
end
