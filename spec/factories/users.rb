FactoryBot.define do
  factory :user do
    first_name { FFaker::Name.first_name  }
    last_name { FFaker::Name.last_name }
    role { 1 }
    password { 'password' }
    email { FFaker::Internet.email }
  end
end
