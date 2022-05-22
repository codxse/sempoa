require 'rails_helper'

RSpec.describe Jwt::BlacklistedToken, type: :model do
  context 'association' do
    it { is_expected.to belong_to(:user).class_name("User") }
  end

  context "validations" do
    let(:subject) { FactoryBot.create :jwt_blacklisted_token }

    it { is_expected.to validate_presence_of(:jti) }
    it { is_expected.to validate_uniqueness_of(:jti) }
  end

  context '#self.blacklist!' do
  it 'should create blacklist' do
    mock_user = FactoryBot.create :user
    Jwt::BlacklistedToken.blacklist!(jti: 'a', exp: 90.minutes.from_now, user: mock_user)

    expect(Jwt::BlacklistedToken.find_by(jti: 'a')).to_not be nil?
  end

  it 'should not create blackils if exist' do
    mock_user = FactoryBot.create :user
    Jwt::BlacklistedToken.blacklist!(jti: 'a', exp: 90.minutes.from_now, user: mock_user)
    Jwt::BlacklistedToken.blacklist!(jti: 'a', exp: 90.minutes.from_now, user: mock_user)

    expect(Jwt::BlacklistedToken.where(jti: 'a').count).to eq 1
  end
end

context '#self.remove!' do
  it 'should remove blacklist from table' do
    mock_user = FactoryBot.create :user
    Jwt::BlacklistedToken.blacklist!(jti: 'a', exp: 90.minutes.from_now, user: mock_user)

    expect(Jwt::BlacklistedToken.where(jti: 'a').count).to eq 1

    Jwt::BlacklistedToken.remove!(jti: 'a')

    expect(Jwt::BlacklistedToken.where(jti: 'a').count).to eq 0
  end
end
end
