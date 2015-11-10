class AddDateofeventToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :dateofevent, :date
  end
end
