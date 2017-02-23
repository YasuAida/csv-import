class AddCommissionPayDateToYafuokus < ActiveRecord::Migration
  def change
    add_column :yafuokus, :commission_pay_date, :date
  end
end
