class AddAdditionToRakutenSettings < ActiveRecord::Migration
  def change
    add_column :rakuten_settings, :addition, :integer
  end
end
