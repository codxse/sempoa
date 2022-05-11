FactoryBot.define do
  factory :jwt_blacklisted_token, class: 'Jwt::BlacklistedToken' do
    jti { Jwt::EncoderModule.generate_unique }
    user { FactoryBot.create :user }
    exp { 90.minutes.from_now }
  end
end
