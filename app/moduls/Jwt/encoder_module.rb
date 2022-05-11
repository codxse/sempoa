module Jwt
  module EncoderModule
    module_function

    def encode(user)
      Jwt::EncoderModule.encode! user
    rescue StandardError
      nil
    end

    def encode!(user)
      raise StandardError.new "Errors::Jwt::MissingIdentity" unless user[:id]

      jti = Jwt::EncoderModule.generate_unique
      exp = Jwt::EncoderModule.expiry
      access_token = JWT.encode(
        {
          sub: user[:id],
          name: user[:name],
          jti: jti,
          iat: issued_at.to_i,
          exp: exp
        },
        Jwt::ConstantsModule::SECRET,
        Jwt::ConstantsModule::ALGO,
        )

      [access_token, jti, exp]
    end
    def generate_unique
      SecureRandom.base64(24)
    end

    def expiry
      (issued_at + 90.minutes).to_i
    end

    def issued_at
      Time.now
    end
  end
end
