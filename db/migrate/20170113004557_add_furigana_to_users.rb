class AddFuriganaToUsers < ActiveRecord::Migration
  def change
    add_column :users, :furigana, :string
  end
end
