class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name
      t.integer :role, null: false
      t.string :password, null: false
      t.string :username
      t.string :email, null: false
      t.boolean :email_verified, default: false

      t.timestamps
    end

    add_index :users, [:username, :email], unique: true
  end
end
