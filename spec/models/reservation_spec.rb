# spec/models/reservation_spec.rb
require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe "associations" do
    it { should belong_to(:guest) }
  end

  describe "enums" do
    it do
      should define_enum_for(:status)
        .with_values([ :pending, :accepted ])
    end

    it do
      should define_enum_for(:currency)
        .with_values([ :USD, :EUR, :GBP, :CAD, :AUD, :PHP ])
    end
  end

  describe "validations" do
    subject { build(:reservation) } # ensures uniqueness and presence checks work

    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }
    it { should validate_presence_of(:nights) }
    it { should validate_presence_of(:number_of_adults) }
    it { should validate_presence_of(:number_of_children) }
    it { should validate_presence_of(:number_of_infants) }
    it { should validate_presence_of(:currency) }
    it { should validate_presence_of(:payout_price_in_cents) }
    it { should validate_presence_of(:security_price_in_cents) }
    it { should validate_presence_of(:total_price_in_cents) }
    it { should validate_presence_of(:status) }
    it { should validate_numericality_of(:nights).only_integer.is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:number_of_adults).only_integer.is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:number_of_children).only_integer.is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:number_of_infants).only_integer.is_greater_than_or_equal_to(0) }

    it { should validate_numericality_of(:payout_price_in_cents).only_integer.is_greater_than(0) }
    it { should validate_numericality_of(:security_price_in_cents).only_integer.is_greater_than(0) }
    it { should validate_numericality_of(:total_price_in_cents).only_integer.is_greater_than(0) }
  end
end
