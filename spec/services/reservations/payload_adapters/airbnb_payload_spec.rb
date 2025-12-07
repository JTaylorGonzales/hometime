require 'rails_helper'

RSpec.describe Reservations::PayloadAdapters::AirbnbPayload do
  include_context "payloads"

  it_behaves_like "a payload adapter"

  subject(:adapter) { described_class.new(airbnb_payload.deep_symbolize_keys) }

 describe ".matches_schema?" do
    it "matches the Airbnb schema" do
      expect(adapter.matches_schema?).to eq(true)
    end

    it "does not match Booking schemas" do
      booking_com = described_class.new(booking_com_payload.deep_symbolize_keys)
      expect(booking_com.matches_schema?).to eq(false)
    end
  end

  describe "#normalize" do
    it "returns a normalized Hash with required keys" do
      data = adapter.normalize
      expect(data).to include(:start_date, :guest_email, :currency)
    end
  end
end
