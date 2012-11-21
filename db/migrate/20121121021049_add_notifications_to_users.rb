class AddNotificationsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notf_new_activity, :boolean, default: true
    add_column :users, :notf_activity_turns_on, :boolean, default: true
  end
end
