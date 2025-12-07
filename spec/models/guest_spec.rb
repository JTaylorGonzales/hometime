require 'rails_helper'

RSpec.describe Guest, type: :model do
  describe "associations" do
    it { should have_many(:reservations).dependent(:destroy) }
  end

  describe "validations" do
    subject { create(:guest) } # ensures uniqueness validation works

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:phone_numbers) }
  end
end
