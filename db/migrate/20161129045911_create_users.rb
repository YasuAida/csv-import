class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :postal_code
      t.string :address
      t.string :telephone_number
      t.string :email
      t.string :password_digest

      t.timestamps null: false
      
      t.index :email, unique: true
    end
  end
end
