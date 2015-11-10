class FixColumnName < ActiveRecord::Migration
  def up
  	change_table :loves do |t|
  		t.rename :user_id, :lover_id
  		t.rename :micropost_id, :loved_id
  	end
  end

  def down
  end
end
