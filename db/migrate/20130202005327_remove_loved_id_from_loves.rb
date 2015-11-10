class RemoveLovedIdFromLoves < ActiveRecord::Migration
  def up
  	  	remove_column :loves, :loved_id
  end

  def down
  end
end
