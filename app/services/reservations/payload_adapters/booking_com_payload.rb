module Reservations
  module PayloadAdapters
    class BookingComPayload < BaseAdapter
      PAYLOAD_SCHEMA = {
        start_date: String,
        end_date: String,
        nights: Integer,
        number_of_guests: Integer,
        guest_details: Hash,
        status_type: String,
        guest_id: Integer,
        guest_first_name: String,
        guest_last_name: String,
        guest_phone_numbers: Array,
        guest_email: String,
        host_currency: String,
        expected_payout_amount: String,
        listing_security_price_accurate: String,
        total_paid_amount_accurate: String
      }.freeze

      def initialize(payload)
        @params = payload[:reservation] || payload
      end

      private
      def normalize_payload
        {
          start_date: params[:start_date],
          end_date: params[:end_date],
          nights: params[:nights],
          guests: params[:number_of_guests],
          adults: params.dig(:guest_details, :number_of_adults),
          children: params.dig(:guest_details, :number_of_children),
          infants: params.dig(:guest_details, :number_of_infants),
          status: params[:status_type],
          guest_external_id: params[:guest_id],
          guest_first_name: params[:guest_first_name],
          guest_last_name: params[:guest_last_name],
          guest_phone: params[:guest_phone_numbers],
          guest_email: params[:guest_email],
          currency: params[:host_currency],
          payout_price_in_cents: params[:expected_payout_amount].to_i * 100,
          security_price_in_cents: params[:listing_security_price_accurate].to_i * 100,
          total_price_in_cents: params[:total_paid_amount_accurate].to_i * 100
        }
      end
    end
  end
end
