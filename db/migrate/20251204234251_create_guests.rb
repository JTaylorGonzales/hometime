class CreateGuests < ActiveRecord::Migration[8.1]
  def change
    create_table :guests do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone_numbers, array: true, default: []

      t.timestamps
    end
    add_index :guests, :email, unique: true
  end
end
