class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.integer :host_id
      t.integer :guest_id
      t.integer :group_id

      t.timestamps
    end
  end
end
