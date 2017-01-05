class AddMethodToExpenseTitles < ActiveRecord::Migration
  def change
    add_column :expense_titles, :method, :string
  end
end
