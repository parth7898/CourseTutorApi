require "rails_helper"

RSpec.describe Tutor, type: :model do
  subject { create(:tutor) }

  describe "associations" do
    it { should belong_to(:course) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }

    it { should validate_presence_of(:email) }

    it { should validate_uniqueness_of(:email) }
  end
end
