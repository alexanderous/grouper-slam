class AddHideToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :hide, :boolean
  end
end
