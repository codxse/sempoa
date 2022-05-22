require 'rails_helper'

RSpec.describe Jwt::RefreshToken, type: :model do
  context 'association' do
    it { is_expected.to belong_to(:user).class_name("User") }
  end

  context "validations" do
    let(:subject) { FactoryBot.create :jwt_refresh_token }

    it { is_expected.to validate_uniqueness_of(:crypted_token) }
  end

  context "callbacks" do
    it 'call :before_create' do
      refresh_token = FactoryBot.create :jwt_refresh_token
      expect(refresh_token.crypted_token).to_not be nil?
    end
  end
end
