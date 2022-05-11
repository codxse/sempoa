module Jwt
  class RefreshToken < ApplicationRecord
    belongs_to :user
  end
end
