require "rails_helper"

RSpec.describe ReservationsController, type: :controller do
  include_context "payloads"

  describe "POST #create" do
    it "returns 200 for valid booking payload" do
      post :create, params: airbnb_payload, as: :json

      expect(response).to have_http_status(:created)
      expect(response.parsed_body["reservation"]["id"]).to eq(Reservation.first.id)
    end

    it "returns 422 for invalid payload" do
      invalid_airbnb_payload = airbnb_payload.deep_dup
      invalid_airbnb_payload[:guest][:first_name] = ""

      post :create, params: invalid_airbnb_payload, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body["error"]).to include("First name can't be blank")
    end
  end
end
