class AddGlFlagToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :gl_flag, :boolean, default: false, null: false
  end
end
