class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :periods do |t|
      t.date :period_start
      t.date :period_end

      t.timestamps null: false
    end
  end
end
