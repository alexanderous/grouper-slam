class AddInitiateTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :initiate_token, :string
  end
end
