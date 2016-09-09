class CreateSubscribes < ActiveRecord::Migration[5.0]
  def change
    create_table :subscribes do |t|
      t.integer :book_id
      t.integer :user_id

      t.timestamps
    end
    add_index :subscribes, :book_id
    add_index :subscribes, :user_id
  end
end
