class AddDestroyCheckToVouchers < ActiveRecord::Migration
  def change
    add_column :vouchers, :destroy_check, :boolean, default: false, null: false
  end
end
