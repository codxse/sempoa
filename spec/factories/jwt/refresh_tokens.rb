FactoryBot.define do
  factory :jwt_refresh_token, class: 'Jwt::RefreshToken' do
    user { FactoryBot.create(:user) }
  end
end
