FactoryBot.define do
  factory :jwt_whitelisted_token, class: 'Jwt::WhitelistedToken' do
    jti { Jwt::EncoderModule.generate_unique }
    user { FactoryBot.create :user }
    exp { 90.minutes.from_now }
  end
end
