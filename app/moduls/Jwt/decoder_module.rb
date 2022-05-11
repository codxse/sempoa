module Jwt
  module DecoderModule
    module_function

    def decode!(access_token, verify: true, options: {})
      default_options = {
        algorithm: Jwt::ConstantsModule::ALGO,
        verify_expiration: true
      }
      options = default_options.merge(options)
      decoded = JWT.decode(access_token, Jwt::ConstantsModule::SECRET, verify, options).first

      raise StandardError.new "Errors::Jwt::InvalidToken" unless decoded.present?

      decoded.symbolize_keys
    end

    def decode(access_token, verify: true, options: {})
      decode!(access_token, verify: verify, options: options)
    rescue StandardError
      nil
    end
  end
end
