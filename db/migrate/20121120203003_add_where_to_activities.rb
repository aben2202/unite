class AddWhereToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :where, :string
  end
end
