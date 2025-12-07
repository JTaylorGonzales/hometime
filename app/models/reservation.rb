class Reservation < ApplicationRecord
  enum :status, [ :pending, :accepted ]
  enum :currency, [ :USD, :EUR, :GBP, :CAD, :AUD, :PHP ]

  belongs_to :guest

  validates :start_date, :end_date, :nights, :number_of_adults,
  :number_of_children, :number_of_infants, :currency,
  :payout_price_in_cents, :security_price_in_cents, :total_price_in_cents, :status, presence: true

  validates :nights, :number_of_adults,
  :number_of_children, :number_of_infants,  numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates :payout_price_in_cents, :security_price_in_cents,
  :total_price_in_cents, numericality: { only_integer: true, greater_than: 0 }
end
