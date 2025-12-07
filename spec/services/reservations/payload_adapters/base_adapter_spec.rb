require "rails_helper"

RSpec.describe Reservations::PayloadAdapters::BaseAdapter do
  class DummyAdapter < described_class
    PAYLOAD_SCHEMA = { foo: String }

    def normalize_payload
      {
        start_date: "x",
        end_date: "y",
        nights: 1,
        guests: 1,
        adults: 1,
        children: 0,
        infants: 0,
        status: "accepted",
        guest_email: "a@b.com",
        guest_first_name: "A",
        guest_last_name: "B",
        guest_phone: "123",
        guest_external_id: "1",
        currency: "USD",
        payout_price_in_cents: 100,
        security_price_in_cents: 20,
        total_price_in_cents: 120
      }
    end
  end

  let(:adapter) { DummyAdapter.new(foo: "test") }

  it_behaves_like "a payload adapter" do
    let(:adapter) { DummyAdapter.new(foo: "test") }
  end

  describe "#matches_schema?" do
    it "returns true when schema matches" do
      expect(adapter.matches_schema?).to eq(true)
    end

    it "returns false when schema does not match" do
      bad = DummyAdapter.new(foo: 123)
      expect(bad.matches_schema?).to eq(false)
    end
  end

  describe "#normalize" do
    it "returns normalized data when valid" do
      expect(adapter.normalize).to be_a(Hash)
    end

    it "raises KeyError when required keys are missing" do
      invalid_payload = Class.new(described_class) do
        PAYLOAD_SCHEMA = { foo: String }
        def normalize_payload
          { foo: "bar" }
        end
      end

      expect { invalid_payload.new(foo: "bar").normalize }.to raise_error(KeyError)
    end
  end
end
