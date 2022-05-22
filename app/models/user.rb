#     Column     |              Type              | Collation | Nullable |              Default              | Storage  | Stats target | Description
# ---------------+--------------------------------+-----------+----------+-----------------------------------+----------+--------------+-------------
# id             | bigint                         |           | not null | nextval('users_id_seq'::regclass) | plain    |              |
# first_name     | character varying              |           | not null |                                   | extended |              |
# last_name      | character varying              |           |          |                                   | extended |              |
# role           | integer                        |           | not null |                                   | plain    |              |
# password       | character varying              |           | not null |                                   | extended |              |
# username       | character varying              |           |          |                                   | extended |              |
# email          | character varying              |           | not null |                                   | extended |              |
# email_verified | boolean                        |           |          | false                             | plain    |              |
# created_at     | timestamp(6) without time zone |           | not null |                                   | plain    |              |
# updated_at     | timestamp(6) without time zone |           | not null |                                   | plain    |              |
# Indexes:
#   "users_pkey" PRIMARY KEY, btree (id)
#   "index_users_on_username_and_email" UNIQUE, btree (username, email)
# Referenced by:
#   TABLE "jwt_whitelisted_tokens" CONSTRAINT "fk_rails_4adcbf9512" FOREIGN KEY (user_id) REFERENCES users(id)
#   TABLE "jwt_refresh_tokens" CONSTRAINT "fk_rails_612bc81d2c" FOREIGN KEY (user_id) REFERENCES users(id)
#   TABLE "jwt_blacklisted_tokens" CONSTRAINT "fk_rails_cdaa1b1284" FOREIGN KEY (user_id) REFERENCES users(id)

class User < ApplicationRecord
  has_many :jwt_refresh_tokens, class_name: 'Jwt::RefreshToken', dependent: :delete_all
  has_many :jwt_whitelisted_tokens, class_name: 'Jwt::WhitelistedToken', dependent: :delete_all
  has_many :jwt_blacklisted_tokens, class_name: 'Jwt::BlacklistedToken', dependent: :delete_all

  validates :email, presence: true
  validates :email, uniqueness: true

  enum role: [:admin, :regular]
end
