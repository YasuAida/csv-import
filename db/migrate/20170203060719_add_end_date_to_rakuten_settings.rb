class AddEndDateToRakutenSettings < ActiveRecord::Migration
  def change
    add_column :rakuten_settings, :end_date, :date
  end
end
