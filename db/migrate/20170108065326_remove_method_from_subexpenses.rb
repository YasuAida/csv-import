class RemoveMethodFromSubexpenses < ActiveRecord::Migration
  def change
    remove_column :subexpenses, :method, :string
  end
end
