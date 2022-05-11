module Jwt
  class BlacklistedToken < ApplicationRecord
    belongs_to :user
    validates :jti, presence: true, uniqueness: true
  end
end

