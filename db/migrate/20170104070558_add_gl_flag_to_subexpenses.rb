class AddGlFlagToSubexpenses < ActiveRecord::Migration
  def change
    add_column :subexpenses, :gl_flag, :boolean, default: false, null: false
  end
end
