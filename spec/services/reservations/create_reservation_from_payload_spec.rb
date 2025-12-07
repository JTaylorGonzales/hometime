require "rails_helper"

RSpec.describe Reservations::CreateReservationFromPayload do
  include_context "payloads"

  describe ".call" do
    it "creates a reservation from Airbnb payload" do
      result = described_class.call(airbnb_payload)

      expect(result).to be_success
      expect(Reservation.count).to eq(1)
      expect(Guest.count).to eq(1)
    end

    it "creates a reservation from Booking payload" do
      result = described_class.call(booking_com_payload)

      expect(result).to be_success
      expect(Reservation.count).to eq(1)
    end

    it "returns failure for invalid guest data" do
      invalid_payload = airbnb_payload.deep_dup
      invalid_payload[:guest][:first_name] = ""

      result = described_class.call(invalid_payload)

      expect(result.success?).to eq(false)
      expect(result.errors.first).to eq("First name can't be blank")
    end
  end
end
