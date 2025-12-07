require "rails_helper"
RSpec.describe ServiceResult do
  it "wraps a success object" do
    r = described_class.success("ok")
    expect(r.success?).to eq(true)
    expect(r.data).to eq("ok")
  end

  it "wraps an error" do
    r = described_class.failure([ "bad" ], :unprocessable_entity)
    expect(r.success?).to eq(false)
    expect(r.errors).to eq([ "bad" ])
  end
end
