class CreateBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|

      t.string :name
      t.string :description
      t.boolean :is_public
      t.integer :user_id


      t.timestamps
    end

    add_index :books, :user_id
  end
end
