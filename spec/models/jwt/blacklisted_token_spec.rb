require 'rails_helper'

RSpec.describe Jwt::BlacklistedToken, type: :model do
  context 'association' do
    it "define associations" do
      is_expected.to belong_to(:user).class_name("User")
    end
  end

  context "validations" do
    it "validate presence for required attributes" do
      is_expected.to validate_presence_of(:jti)
    end

    it { is_expected.to validate_uniqueness_of(:jti) }
  end
end
