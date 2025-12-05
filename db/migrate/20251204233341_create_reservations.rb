class CreateReservations < ActiveRecord::Migration[8.1]
  def change
    create_table :reservations do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.integer :nights
      t.integer :number_of_adults
      t.integer :number_of_children
      t.integer :number_of_infants
      t.integer :status, default: 0
      t.integer :currency
      t.integer :payout_price_in_cents
      t.integer :security_price_in_cents
      t.integer :total_price_in_cents
      t.string :guest_external_id
      t.jsonb :meta_data

      t.timestamps
    end
  end
end
