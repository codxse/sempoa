class JwtService
  def self.issue_tokens(user)
    access_token, jti, exp = Jwt::EncoderModule.encode(user)
    refresh_token = user.jwt_refresh_tokens.create!
    Jwt::WhitelistedToken.whitelist!(jti: jti, exp: exp, user: user)

    [access_token, refresh_token.crypted_token]
  end 

  def self.refresh_tokens(refresh_token)
  end


  def self.revoke_token(access_token:)
    decoded_token = Jwt::DecoderModule.decode(access_token)

    return false if decoded_token.nil?

    jti = decoded_token[:jti]
    exp = decoded_token[:exp]
    user_id = decoded_token[:sub]
    user = User.find(user_id)

    Jwt::WhitelistedToken.remove_whitelist(jti: jti)
    Jwt::BlacklistedToken.remove_blacklist(jti: jti)
  end
end