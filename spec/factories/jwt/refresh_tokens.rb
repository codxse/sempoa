FactoryBot.define do
  factory :jwt_refresh_token, class: 'Jwt::RefreshToken' do
    crypted_token { Jwt::EncoderModule.generate_unique }
  end
end
