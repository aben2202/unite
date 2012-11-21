class AddCommentNotificationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notf_new_comment, :boolean, default: true
  end
end
