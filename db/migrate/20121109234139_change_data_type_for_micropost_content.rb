class ChangeDataTypeForMicropostContent < ActiveRecord::Migration
  def up
  	change_table :microposts do |t|
  		t.change :content, :text
  	end
  end

  def down
  	change_table :microposts do |t|
  		t.change :content, :string
  	end
  end
end
