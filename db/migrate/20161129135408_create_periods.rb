class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :periods do |t|
      t.references :user, index: true, foreign_key: true 
      t.date :period_start
      t.date :period_end

      t.timestamps null: false
    end
  end
end
