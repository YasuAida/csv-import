class CreateExpenseTitles < ActiveRecord::Migration
  def change
    create_table :expense_titles do |t|
      t.string :item

      t.timestamps null: false
    end
  end
end
