class AddLogoToBooks < ActiveRecord::Migration[5.0]
  def change
  	add_attachment :books, :logo
  end
end
