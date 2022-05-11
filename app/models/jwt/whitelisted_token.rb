module Jwt
  class WhitelistedToken < ApplicationRecord
    belongs_to :user
  end
end
