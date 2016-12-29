class AddDisplayPositionToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :display_position, :string
  end
end
