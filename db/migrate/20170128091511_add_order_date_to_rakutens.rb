class AddOrderDateToRakutens < ActiveRecord::Migration
  def change
    add_column :rakutens, :order_date, :date
  end
end
