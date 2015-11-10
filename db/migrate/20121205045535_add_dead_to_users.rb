class AddDeadToUsers < ActiveRecord::Migration
  def change
    add_column :users, :dead, :boolean
  end
end
