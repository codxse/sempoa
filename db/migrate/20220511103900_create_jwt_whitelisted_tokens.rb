class CreateJwtWhitelistedTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :jwt_whitelisted_tokens do |t|
      t.string :jti
      t.belongs_to :user, null: false, foreign_key: true
      t.datetime :exp

      t.timestamps
    end
    add_index :jwt_whitelisted_tokens, :jti, unique: true
  end
end
