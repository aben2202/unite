class DropGenericActivities < ActiveRecord::Migration
  def up
  	drop_table :generic_activities
  end

  def down
  	raise ActiveRecord::IrreversibleMigration
  end
end
