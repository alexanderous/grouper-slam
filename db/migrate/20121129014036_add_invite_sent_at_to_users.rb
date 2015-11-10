class AddInviteSentAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :invite_sent_at, :datetime
  end
end
