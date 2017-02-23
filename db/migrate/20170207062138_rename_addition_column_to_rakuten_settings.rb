class RenameAdditionColumnToRakutenSettings < ActiveRecord::Migration
  def change
    rename_column :rakuten_settings, :addition, :pc_addition
    add_column :rakuten_settings, :mobile_addition, :integer    
  end
end
