class RemoveDebitamountFromGeneralledgers < ActiveRecord::Migration
  def change
    remove_column :generalledgers, :debit_amount, :integer
    remove_column :generalledgers, :credit_amount, :integer    
  end
end
