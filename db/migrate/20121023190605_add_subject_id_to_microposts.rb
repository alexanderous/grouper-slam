class AddSubjectIdToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :subject_id, :integer, default: @user_id
  end
end
