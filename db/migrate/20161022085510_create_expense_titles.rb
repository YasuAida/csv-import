class CreateExpenseTitles < ActiveRecord::Migration
  def change
    create_table :expense_titles do |t|
      t.references :user, index: true, foreign_key: true      
      t.string :item

      t.timestamps null: false
    end
  end
end
