class AddLoveColumnsToLoves < ActiveRecord::Migration
  def change
    add_column :loves, :loved_id, :integer
    add_column :loves, :lover_id, :integer
  end
end
