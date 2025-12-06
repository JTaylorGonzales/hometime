module Reservations
  class UnknownPayloadError < StandardError; end
  class AmbiguousPayloadError < StandardError; end

  class AdapterResolver
    ADAPTERS = [
      PayloadAdapters::AirbnbPayload,
      PayloadAdapters::BookingComPayload
  ]

    def self.resolve(payload)
      matched = ADAPTERS.map { |adapter_class| adapter_class.new(payload) }
                    .select { |adapter_instance| adapter_instance.matches_schema? }

      case matched.size
      when 1
        matched.first
      when 0
        raise UnknownPayloadError, "No adapter matched the payload schema"
      else
        raise AmbiguousPayloadError, "Multiple adapters matched the payload schema"
      end
    end
  end
end
