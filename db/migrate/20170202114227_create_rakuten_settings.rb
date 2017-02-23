class CreateRakutenSettings < ActiveRecord::Migration
  def change
    create_table :rakuten_settings do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :sales_bracket
      t.float :pc_rate
      t.float :mobile_rate
      t.boolean :destroy_check, default: false, null: false

      t.timestamps null: false
    end
  end
end
