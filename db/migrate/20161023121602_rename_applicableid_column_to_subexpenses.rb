class RenameApplicableidColumnToSubexpenses < ActiveRecord::Migration
  def change
    rename_column :subexpenses, :applicable_id, :targetgood
  end
end
