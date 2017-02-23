class CreatePointCoupons < ActiveRecord::Migration
  def change
    create_table :point_coupons do |t|
      t.string :order_num
      t.integer :shop_coupon
      t.integer :use_point
      t.integer :use_coupon

      t.timestamps null: false
    end
  end
end
