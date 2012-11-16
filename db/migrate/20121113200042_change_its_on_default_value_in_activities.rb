class ChangeItsOnDefaultValueInActivities < ActiveRecord::Migration
  def up
  	change_column :activities, :its_on, :boolean, default: false
  end

  def down
  	change_column :activities, :its_on, :boolean, default: nil
  end
end
