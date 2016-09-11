class AddOnshelfDayToBooks < ActiveRecord::Migration[5.0]
  def change
  	add_column :books, :onshelf_day, :datetime
  end
end
