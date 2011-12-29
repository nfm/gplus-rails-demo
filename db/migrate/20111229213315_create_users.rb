class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :token
      t.string :refresh_token
      t.integer :token_expires_at
      t.timestamps
    end
  end
end
