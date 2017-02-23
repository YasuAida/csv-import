class AddUserToPointCoupons < ActiveRecord::Migration
  def change
    add_reference :point_coupons, :user, index: true, foreign_key: true
  end
end
