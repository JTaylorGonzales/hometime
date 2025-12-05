class AddGuestIdToReservations < ActiveRecord::Migration[8.1]
  def change
    add_reference :reservations, :guest, null: false, foreign_key: true
  end
end
