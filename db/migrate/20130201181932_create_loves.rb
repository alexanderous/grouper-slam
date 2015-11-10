class CreateLoves < ActiveRecord::Migration
  def change
    create_table :loves do |t|
      t.string :micropost_id
      t.string :user_id


      t.timestamps
    end
  end
end
