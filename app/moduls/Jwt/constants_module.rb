module Jwt
  module ConstantsModule
    ALGO = 'HS512'
    SECRET = ENV.fetch('JWT_SECRET')
  end
end
