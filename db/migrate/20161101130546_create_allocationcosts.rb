class CreateAllocationcosts < ActiveRecord::Migration
  def change
    create_table :allocationcosts do |t|
      t.references :stock, index: true, foreign_key: true
      t.string :title
      t.integer :allocation_amount

      t.timestamps null: false

    end
  end
end
