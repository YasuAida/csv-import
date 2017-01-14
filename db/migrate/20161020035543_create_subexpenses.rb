class CreateSubexpenses < ActiveRecord::Migration
  def change
    create_table :subexpenses do |t|
      t.references :user, index: true, foreign_key: true      
      t.string :item
      t.string :method
      t.date :date
      t.string :purchase_from
      t.float :amount
      t.string :applicable_id

      t.timestamps null: false
    end
  end
end
