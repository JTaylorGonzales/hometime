module Reservations
  class UnknownPayloadError < StandardError; end

  class CreateReservationFromPayload
    def self.call(payload)
      new(payload).call
    end

    def initialize(payload)
      @payload = payload.deep_symbolize_keys
    end

    def call
      normalized_data = adapter.new(payload).normalize

      result = create_reservation(normalized_data)
      if result.persisted?
        ServiceResult.success(result)
      else
        ServiceResult.failure(result.errors.full_messages)
      end
    end

    private

    def adapter
      case
      when airbnb_payload?
        PayloadAdapters::AirbnbPayload
      when booking_com_payload?
        PayloadAdapters::BookingComPayload
      else
        raise UnknownPayloadError, "Unknown payload structure"
      end
    end

    def airbnb_payload?
      payload.key?(:guest)
    end

    def booking_com_payload?
      payload.key?(:reservation)
    end

    def create_reservation(data)
      guest = Guest.find_or_initialize_by(email: data[:guest_email])

      guest.assign_attributes(
        first_name: data[:guest_first_name],
        last_name: data[:guest_last_name],
        phone_numbers: Array(data[:guest_phone])
      )

      return guest unless guest.save

      guest.reservations.create(
        start_date: data[:start_date],
        end_date: data[:end_date],
        nights: data[:nights],
        number_of_adults: data[:adults],
        number_of_children: data[:children],
        number_of_infants: data[:infants],
        status: data[:status],
        currency: data[:currency],
        payout_price_in_cents: data[:payout_price_in_cents],
        security_price_in_cents: data[:security_price_in_cents],
        total_price_in_cents: data[:total_price_in_cents],
        guest_external_id: data[:guest_external_id],
        raw_payload: payload
      )
    end

    attr_reader :payload
  end
end
