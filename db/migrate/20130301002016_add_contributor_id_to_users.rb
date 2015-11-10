class AddContributorIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :contributor_id, :integer
  end
end
