class AddDestroyCheckToMultiChannels < ActiveRecord::Migration
  def change
    add_column :multi_channels, :destroy_check, :boolean, default: false, null: false
  end
end
