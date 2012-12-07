class AddResponseToInvite < ActiveRecord::Migration
  def change
    add_column :invites, :response, :integer
  end
end
