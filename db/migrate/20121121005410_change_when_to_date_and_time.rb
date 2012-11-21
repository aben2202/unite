class ChangeWhenToDateAndTime < ActiveRecord::Migration
  def up
  	rename_column :activities, :when, :date_and_time
  end

  def down
  	rename_column :activities, :date_and_time, :when
  end
end
