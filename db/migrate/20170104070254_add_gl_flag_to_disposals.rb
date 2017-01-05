class AddGlFlagToDisposals < ActiveRecord::Migration
  def change
    add_column :disposals, :gl_flag, :boolean, default: false, null: false
  end
end
