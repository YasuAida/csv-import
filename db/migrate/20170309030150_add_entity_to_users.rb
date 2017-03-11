class AddEntityToUsers < ActiveRecord::Migration
  def change
    add_column :users, :entity, :string
  end
end
