class CreateBookGroupships < ActiveRecord::Migration[5.0]
  def change
    create_table :book_groupships do |t|
      t.integer :book_id
      t.integer :group_id

      t.timestamps
    end
    add_index :book_groupships, :book_id 
    add_index :book_groupships, :group_id
  end
end
