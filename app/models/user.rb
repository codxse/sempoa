class User < ApplicationRecord
  has_many :jwt_refresh_tokens, dependent: :delete_all
  has_many :jwt_whitelisted_tokens, dependent: :delete_all
  has_many :jwt_blacklisted_tokens, dependent: :delete_all

  enum role: {
    admin: 0,
    regular: 1
  }, _prefix: true
end
