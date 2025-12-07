# spec/factories/reservations.rb
FactoryBot.define do
  factory :reservation do
    start_date { Date.today }
    end_date { Date.today + 3 }
    nights { 3 }
    number_of_adults { 2 }
    number_of_children { 1 }
    number_of_infants { 0 }
    status { :pending }
    currency { :USD }
    payout_price_in_cents { 30000 }
    security_price_in_cents { 5000 }
    total_price_in_cents { 35000 }
    guest_external_id { "guest_#{SecureRandom.hex(4)}" }
    raw_payload { {} }
    association :guest
  end
end
