class AddGlFlagToPladmins < ActiveRecord::Migration
  def change
    add_column :pladmins, :gl_flag, :boolean, default: false, null: false
  end
end
