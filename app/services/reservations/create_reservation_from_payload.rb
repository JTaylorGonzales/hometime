module Reservations
  class CreateReservationFromPayload
    def initialize(payload)
      @payload = payload.deep_symbolize_keys
    end

    def self.call(payload)
      new(payload).call
    end

    def call
      normalized_data = AdapterResolver.resolve(payload).normalize

      result = create_reservation(normalized_data)
      if result.valid? && result.persisted?
        ServiceResult.success(result)
      else
        ServiceResult.failure(result.errors.full_messages)
      end

    rescue UnknownPayloadError => e
      Rails.logger.warn("Unknown payload received: #{payload.inspect}")
      ServiceResult.failure("Unknown Payload", :bad_request)
    rescue AmbiguousPayloadError => e
      Rails.logger.error("Ambiguous payload error: #{e.message}")
      ServiceResult.failure("Internal Server error", :internal_server_error)
    end

    private
    def create_reservation(data)
      guest = Guest.find_or_initialize_by(email: data[:guest_email])

      guest.assign_attributes(
        first_name: data[:guest_first_name],
        last_name: data[:guest_last_name],
        phone_numbers: Array(data[:guest_phone])
      )

      return guest unless guest.valid?

      guest.save
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
