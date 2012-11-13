class RenameSpecificActivitiesToActivities < ActiveRecord::Migration
  def up
  	rename_table :specific_activities, :activities
  end

  def down
  	rename_table :activities, :specific_activities
  end
end
