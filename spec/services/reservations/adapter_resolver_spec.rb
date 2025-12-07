require "rails_helper"

RSpec.describe Reservations::AdapterResolver do
  include_context "payloads"

  describe ".resolve" do
    it "returns Airbnb adapter for Airbnb payload" do
      adapter = described_class.resolve(airbnb_payload)
      expect(adapter).to be_a(Reservations::PayloadAdapters::AirbnbPayload)
    end

    it "returns BookingCom adapter for booking payload" do
      adapter = described_class.resolve(booking_com_payload)
      expect(adapter).to be_a(Reservations::PayloadAdapters::BookingComPayload)
    end

    it "raises UnknownPayloadError if no matches" do
      expect {
        described_class.resolve({})
      }.to raise_error(Reservations::UnknownPayloadError)
    end
  end
end
