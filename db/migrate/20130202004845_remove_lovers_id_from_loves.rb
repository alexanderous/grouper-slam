class RemoveLoversIdFromLoves < ActiveRecord::Migration
  def up
  	remove_column :loves, :lover_id
  end

  def down
  end
end
