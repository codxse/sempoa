class CreateJwtRefreshTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :jwt_refresh_tokens do |t|
      t.string :crypted_token
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :jwt_refresh_tokens, :crypted_token, unique: true
  end
end
