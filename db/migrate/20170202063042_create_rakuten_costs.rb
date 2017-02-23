class CreateRakutenCosts < ActiveRecord::Migration
  def change
    create_table :rakuten_costs do |t|
      t.date :billing_date
      t.integer :pc_usage_fee
      t.integer :mobile_usage_fee
      t.integer :pc_vest_point
      t.integer :mobile_vest_point
      t.integer :affiliate_reward
      t.integer :affiliate_system_fee
      t.integer :r_card_plus
      t.integer :system_improvement_fee
      t.integer :open_shop_fee
      t.date :payment_date
      t.integer :sales_bracket
      t.float :pc_rate
      t.float :mobile_rate
      
      t.timestamps null: false
    end
  end
end
