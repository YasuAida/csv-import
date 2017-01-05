class AddGlFlagToStockreturns < ActiveRecord::Migration
  def change
    add_column :stockreturns, :gl_flag, :boolean, default: false, null: false
  end
end
