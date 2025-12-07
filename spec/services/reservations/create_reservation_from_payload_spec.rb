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

    context "guest handling" do
      it "updates existing guest when email matches" do
        existing_guest = Guest.create!(
          email: "wayne_woodbridge@bnb.com",
          first_name: "Old",
          last_name: "Name",
          phone_numbers: [ "123" ]
        )

        result = described_class.call(airbnb_payload)

        expect(result).to be_success
        expect(Guest.count).to eq(1)
        expect(existing_guest.reload.first_name).to eq(airbnb_payload[:guest][:first_name])
      end

      it "creates multiple reservations for same guest" do
        described_class.call(airbnb_payload)
        second_payload = airbnb_payload.deep_dup
        second_payload[:start_date] = "2025-12-15"

        result = described_class.call(second_payload)

        expect(result).to be_success
        expect(Guest.count).to eq(1)
        expect(Reservation.count).to eq(2)
      end

      it "returns failure for invalid guest data" do
        invalid_payload = airbnb_payload.deep_dup
        invalid_payload[:guest][:first_name] = ""

        result = described_class.call(invalid_payload)

        expect(result.success?).to eq(false)
        expect(result.errors.first).to eq("First name can't be blank")
      end
    end

    context "validation failures" do
      it "returns failure for invalid reservation data" do
        invalid_payload = airbnb_payload.deep_dup
        invalid_payload[:start_date] = ""

        result = described_class.call(invalid_payload)

        expect(result).not_to be_success
        expect(result.errors).to include(match(/start date/i))
      end

      it "does not create guest when reservation is invalid" do
        invalid_payload = airbnb_payload.deep_dup
        invalid_payload[:start_date] = "invalid-date"

        described_class.call(invalid_payload)
        expect(Guest.count).to eq(0)
      end
    end

    context "error handling" do
      it "returns failure for unknown payload format" do
        unknown_payload = { random: "data" }

        result = described_class.call(unknown_payload)

        expect(result).not_to be_success
        expect(result.errors).to eq("Unknown Payload")
        expect(result.status).to eq(:bad_request)
      end

      it "returns failure for ambiguous payload" do
        ambiguous_payload = airbnb_payload.deep_merge(booking_com_payload)

        result = described_class.call(ambiguous_payload)

        expect(result).not_to be_success
        expect(result.errors).to eq("Internal Server error")
        expect(result.status).to eq(:internal_server_error)
      end

      it "logs warning for unknown payload" do
        allow(Rails.logger).to receive(:warn)

        described_class.call({ invalid: "payload" })

        expect(Rails.logger).to have_received(:warn)
          .with(/Unknown payload received/)
      end

      it "logs error for ambiguous payload" do
        allow(Rails.logger).to receive(:error)
        allow(Reservations::AdapterResolver).to receive(:resolve)
          .and_raise(Reservations::AmbiguousPayloadError.new("Test error"))

        described_class.call(airbnb_payload)

        expect(Rails.logger).to have_received(:error)
          .with(/Ambiguous payload/)
      end
    end
  end
end
