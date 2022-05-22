require 'rails_helper'

RSpec.describe Jwt::WhitelistedToken, type: :model do
  context 'association' do
    it { is_expected.to belong_to(:user).class_name("User") }
  end

  context "validations" do
    let(:subject) { FactoryBot.create :jwt_whitelisted_token }

    it { is_expected.to validate_presence_of(:jti) }
    it { is_expected.to validate_uniqueness_of(:jti) }
  end

  context '#self.whitelist!' do
    it 'should create whitelist' do
      mock_user = FactoryBot.create :user
      Jwt::WhitelistedToken.whitelist!(jti: 'a', exp: 90.minutes.from_now, user: mock_user)

      expect(Jwt::WhitelistedToken.find_by(jti: 'a')).to_not be nil?
    end

    it 'should not create whitelist if exist' do
      mock_user = FactoryBot.create :user
      Jwt::WhitelistedToken.whitelist!(jti: 'a', exp: 90.minutes.from_now, user: mock_user)
      Jwt::WhitelistedToken.whitelist!(jti: 'a', exp: 90.minutes.from_now, user: mock_user)

      expect(Jwt::WhitelistedToken.where(jti: 'a').count).to eq 1
    end
  end

  context '#self.remove!' do
    it 'should remove whitelist from table' do
      mock_user = FactoryBot.create :user
      Jwt::WhitelistedToken.whitelist!(jti: 'a', exp: 90.minutes.from_now, user: mock_user)

      expect(Jwt::WhitelistedToken.where(jti: 'a').count).to eq 1

      Jwt::WhitelistedToken.remove!(jti: 'a')

      expect(Jwt::WhitelistedToken.where(jti: 'a').count).to eq 0
    end
  end
end
