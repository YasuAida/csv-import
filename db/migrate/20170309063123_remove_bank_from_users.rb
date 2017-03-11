class RemoveBankFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :bank, :string
  end
end
