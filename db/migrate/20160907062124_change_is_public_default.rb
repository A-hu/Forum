class ChangeIsPublicDefault < ActiveRecord::Migration[5.0]
  def change
  	change_column_default :books, :is_public, false
  	change_column_default :comments, :is_public, false
  end
end
