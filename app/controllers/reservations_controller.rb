class ReservationsController < ApplicationController
  wrap_parameters false
  def create
    result = Reservations::CreateReservationFromPayload.call(params.permit!.except(:controller, :action).to_h)

    if result.success?
      render json: { reservation: result.data }, status: :created
    else
      render json: { error: result.errors }, status: result.status
    end
  end
end
