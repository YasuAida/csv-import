class CreateMultiChannels < ActiveRecord::Migration
  def change
    create_table :multi_channels do |t|
      t.references :user, index: true, foreign_key: true
      t.string :order_num
      t.string :sku

      t.timestamps null: false
    end
  end
end
