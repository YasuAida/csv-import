class AddUserIdToRakutenCosts < ActiveRecord::Migration
  def change
    add_reference :rakuten_costs, :user, index: true, foreign_key: true
  end
end
