class ChangeDataTypeForMicropostSubjectId < ActiveRecord::Migration
  def up
  	change_table :microposts do |t|
  		t.change :subject_id, :bigint
  	end
  end

  def down
  	change_table :microposts do |t|
  		t.change :subject_id, :integer
  	end
  end
end
