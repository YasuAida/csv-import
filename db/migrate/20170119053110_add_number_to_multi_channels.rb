class AddNumberToMultiChannels < ActiveRecord::Migration
  def change
    add_column :multi_channels, :number, :integer, default: 1, null: false
  end
end
