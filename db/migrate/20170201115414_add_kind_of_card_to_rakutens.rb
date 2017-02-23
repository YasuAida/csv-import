class AddKindOfCardToRakutens < ActiveRecord::Migration
  def change
    add_column :rakutens, :kind_of_card, :string
  end
end
