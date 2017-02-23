class AddSalePlaceToYafuokus < ActiveRecord::Migration
  def change
    add_column :yafuokus, :sale_place, :string
  end
end
