RSpec.shared_examples "a payload adapter" do
  it "responds to matches_schema?" do
    expect(adapter).to respond_to(:matches_schema?)
  end

  it "responds to normalize" do
    expect(adapter).to respond_to(:normalize)
  end

  it "raises NotImplementedError if normalize_payload is not implemented" do
    base = Reservations::PayloadAdapters::BaseAdapter.new({})
    expect { base.normalize }.to raise_error(NotImplementedError)
  end
end
