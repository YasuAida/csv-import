class RemoveIndexFromExchange < ActiveRecord::Migration
  def change
    remove_index :exchanges, column: [:date,  :country], name: 'exchange_index'
  end
end
