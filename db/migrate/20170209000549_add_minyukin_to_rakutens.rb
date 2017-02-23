class AddMinyukinToRakutens < ActiveRecord::Migration
  def change
    add_column :rakutens, :minyukin, :integer
  end
end
