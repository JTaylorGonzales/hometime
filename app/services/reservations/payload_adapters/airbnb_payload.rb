module Reservations
  module PayloadAdapters
    class AirbnbPayload < BaseAdapter
      private
      def normalize_payload
        {
          start_date: params[:start_date],
          end_date: params[:end_date],
          nights: params[:nights],
          guests: params[:guests],
          adults: params[:adults],
          children: params[:children],
          infants: params[:infants],
          status: params[:status],
          guest_external_id: params.dig(:guest, :id),
          guest_first_name: params.dig(:guest, :first_name),
          guest_last_name: params.dig(:guest, :last_name),
          guest_phone: params.dig(:guest, :phone),
          guest_email: params.dig(:guest, :email),
          currency: params[:currency],
          payout_price_in_cents: params[:payout_price].to_i * 100,
          security_price_in_cents: params[:security_price].to_i * 100,
          total_price_in_cents: params[:total_price].to_i * 100
        }
      end
    end
  end
end
