class AddBirthYearToUsers < ActiveRecord::Migration
  def change
    add_column :users, :birth_year, :date
  end
end
