class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|

      t.string :name
      t.timestamps
    end
    add_column :books, :category_id, :integer
    add_index :books, :category_id
  end
end
