class RenameSalesBracketColumnToRakutenSettings < ActiveRecord::Migration
  def change
    rename_column :rakuten_settings, :sales_bracket, :start_sales
    add_column :rakuten_settings, :end_sales, :integer 
  end
end
