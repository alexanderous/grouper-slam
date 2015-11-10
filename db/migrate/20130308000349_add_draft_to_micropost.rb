class AddDraftToMicropost < ActiveRecord::Migration
  def change
    add_column :microposts, :draft, :boolean
  end
end
