class CreateUserBookships < ActiveRecord::Migration[5.0]
  def change
    create_table :user_bookships do |t|
      t.integer :book_id
      t.integer :user_id	
      t.timestamps
    end
    add_index :user_bookships, :book_id
    add_index :user_bookships, :user_id
  end
end
