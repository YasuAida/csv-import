class AddHandlingToSales < ActiveRecord::Migration
  def change
    add_column :sales, :handling, :string
  end
end
