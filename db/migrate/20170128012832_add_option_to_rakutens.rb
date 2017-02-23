class AddOptionToRakutens < ActiveRecord::Migration
  def change
    add_column :rakutens, :option, :string
  end
end
