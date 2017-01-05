class AddGlFlagToVouchers < ActiveRecord::Migration
  def change
    add_column :vouchers, :gl_flag, :boolean, default: false, null: false
  end
end
