#    Column     |              Type              | Collation | Nullable |                    Default                     | Storage  | Stats target | Description
# --------------+--------------------------------+-----------+----------+------------------------------------------------+----------+--------------+-------------
# id            | bigint                         |           | not null | nextval('jwt_refresh_tokens_id_seq'::regclass) | plain    |              |
# crypted_token | character varying              |           | not null |                                                | extended |              |
# user_id       | bigint                         |           | not null |                                                | plain    |              |
# created_at    | timestamp(6) without time zone |           | not null |                                                | plain    |              |
# updated_at    | timestamp(6) without time zone |           | not null |                                                | plain    |              |
# Indexes:
#   "jwt_refresh_tokens_pkey" PRIMARY KEY, btree (id)
#   "index_jwt_refresh_tokens_on_crypted_token" UNIQUE, btree (crypted_token)
#   "index_jwt_refresh_tokens_on_user_id" btree (user_id)
# Foreign-key constraints:
#   "fk_rails_612bc81d2c" FOREIGN KEY (user_id) REFERENCES users(id)

module Jwt
  class RefreshToken < ApplicationRecord
    belongs_to :user
    validates :crypted_token, uniqueness: true
    before_create :set_crypted_token

    attr_accessor :token

    def self.find_by_token(refresh_token)
      RefreshToken.find_by(crypted_token: refresh_token)
    end

    private

    def set_crypted_token
      self.token = SecureRandom.hex
      self.crypted_token = Digest::SHA256.hexdigest token
    end
  end
end
