class AddLogoToComments < ActiveRecord::Migration[5.0]
  def change
  	add_attachment :comments, :logo
  end
end
