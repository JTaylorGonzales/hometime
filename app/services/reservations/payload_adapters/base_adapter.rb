module Reservations
  module PayloadAdapters
    class BaseAdapter
      REQUIRED_KEYS = %i[
        start_date
        end_date
        nights
        guests
        adults
        children
        infants
        status
        guest_email
        guest_first_name
        guest_last_name
        guest_phone
        guest_external_id
        currency
        payout_price_in_cents
        security_price_in_cents
        total_price_in_cents
      ].freeze

      def initialize(payload)
        @params = payload
      end

      def matches_schema?
        self.class::PAYLOAD_SCHEMA.all? do |key, klass|
          params.key?(key) && params[key].is_a?(klass)
        end
      end

      def normalize
        normalized = normalize_payload
        validate_keys!(normalized)
        normalized
      end


      private
      attr_reader :params

      def normalize_payload
        raise NotImplementedError, "Subclasses must implement the normalize_payload method"
      end

      def validate_keys!(hash)
        missing = REQUIRED_KEYS - hash.keys
        raise KeyError, "Missing normalized keys: #{missing.join(', ')}" if missing.any?
      end
    end
  end
end
