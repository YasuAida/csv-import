class AddDestroyCheckToExpenseTitles < ActiveRecord::Migration
  def change
    add_column :expense_titles, :destroy_check, :boolean, default: false, null: false
  end
end
