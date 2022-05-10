class JwtService
  SECRET = ENV.fetch('JWT_SECRET')
  ALG = 'HS512'

  def self.encode(payload)
    payload[:exp] = 90.minutes.from_now.to_i
    payload[:iat] = Time.now.to_i
    JWT.encode(payload, SECRET, ALG)
  rescue JWT::DecodeError
    {}
  end

  def self.decode(token, verify: true, options: {})
    default_options = {
      algorithm: ALG,
      verify_expiration: true
    }

    options = default_options.merge(options)
    JWT.decode(token, SECRET, verify, options).first
  rescue JWT::DecodeError
    {}
  end
end
