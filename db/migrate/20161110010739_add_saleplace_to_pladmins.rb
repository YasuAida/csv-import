class AddSaleplaceToPladmins < ActiveRecord::Migration
  def change
    add_column :pladmins, :sale_place, :string
  end
end
