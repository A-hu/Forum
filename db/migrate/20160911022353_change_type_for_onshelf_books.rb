class ChangeTypeForOnshelfBooks < ActiveRecord::Migration[5.0]
  def change
  	change_column :books, :onshelf_day, :date, :default => Time.now
  end
end
