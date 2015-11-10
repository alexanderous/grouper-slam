class ChangeDataTypeForPseudoUserId < ActiveRecord::Migration
  def up
  	change_table :pseudo_users do |t|
  		t.change :id, :bigint
  	end
  end

  def down
  	change_table :pseudo_users do |t|
  		t.change :id, :integer
  	end
  end
end
