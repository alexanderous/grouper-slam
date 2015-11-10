class AddDeathYearToUsers < ActiveRecord::Migration
  def change
    add_column :users, :death_year, :date
  end
end
