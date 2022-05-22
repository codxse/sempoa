#    Column   |              Type              | Collation | Nullable |                      Default                       | Storage  | Stats target | Description 
# ------------+--------------------------------+-----------+----------+----------------------------------------------------+----------+--------------+-------------
#  id         | bigint                         |           | not null | nextval('jwt_blacklisted_tokens_id_seq'::regclass) | plain    |              | 
#  jti        | character varying              |           | not null |                                                    | extended |              | 
#  user_id    | bigint                         |           | not null |                                                    | plain    |              | 
#  exp        | timestamp(6) without time zone |           | not null |                                                    | plain    |              | 
#  created_at | timestamp(6) without time zone |           | not null |                                                    | plain    |              | 
#  updated_at | timestamp(6) without time zone |           | not null |                                                    | plain    |              | 
# Indexes:
#     "jwt_blacklisted_tokens_pkey" PRIMARY KEY, btree (id)
#     "index_jwt_blacklisted_tokens_on_jti" UNIQUE, btree (jti)
#     "index_jwt_blacklisted_tokens_on_user_id" btree (user_id)
# Foreign-key constraints:
#     "fk_rails_cdaa1b1284" FOREIGN KEY (user_id) REFERENCES users(id)

module Jwt
  class BlacklistedToken < ApplicationRecord
    belongs_to :user
    validates :jti, uniqueness: true
    validates :jti, :exp, presence: true

    def self.blacklist!(jti:, exp:, user:)
      user.jwt_blacklisted_tokens.create!(
        jti: jti,
        exp: Time.at(exp)
      ) unless Jwt::BlacklistedToken.exists?(jti: jti)
    end

    def self.remove_blacklist(jti:)
      blacklist = Jwt::BlacklistedToken.find_by(jti: jti)
      blacklist.destroy if blacklist.present?
    end
  end
end
