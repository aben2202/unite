class ChangeInviteGuestIdToGuestEmail < ActiveRecord::Migration
  def up
	rename_column :invites, :guest_id, :guest_email
	change_column :invites, :guest_email, :string
  end

  def down
  	change_column :invites, :guest_email, :integer
  	rename_column :invites, :guest_email, :guest_id
  end
end
