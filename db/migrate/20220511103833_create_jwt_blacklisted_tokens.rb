class CreateJwtBlacklistedTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :jwt_blacklisted_tokens do |t|
      t.string :jti, null: false
      t.belongs_to :user, null: false, foreign_key: true
      t.datetime :exp, null: false

      t.timestamps
    end
    add_index :jwt_blacklisted_tokens, :jti, unique: true
  end
end
