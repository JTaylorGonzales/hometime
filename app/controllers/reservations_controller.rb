class ReservationsController < ApplicationController
  wrap_parameters false
  def create
   result = Reservations::CreateReservationFromPayload.call(params.permit!.except(:controller, :action).to_h)

   if result.success?
     render json: { reservation: result.data }, status: :created
   else
     render json: { error: result.errors }, status: :unprocessable_entity
   end

  rescue Reservations::UnknownPayloadError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
