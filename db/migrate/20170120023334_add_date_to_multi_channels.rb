class AddDateToMultiChannels < ActiveRecord::Migration
  def change
    add_column :multi_channels, :date, :date
  end
end
