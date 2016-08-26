class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.string :name
      t.integer :book_id

      t.timestamps
    end
    add_index :comments, :book_id
  end
end
