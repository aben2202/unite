class CreateSpecificActivities < ActiveRecord::Migration
  def change
    create_table :specific_activities do |t|
      t.string :description
      t.datetime :when,                :null => false
      t.integer :min_participants,     :null => false
      t.integer :max_participants
      t.boolean :its_on

      t.timestamps
    end
  end
end
