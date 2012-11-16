class CreateActivityGroupRelations < ActiveRecord::Migration
  def change
    create_table :activity_group_relations do |t|
      t.integer :activity_id
      t.integer :group_id

      t.timestamps
    end
  end
end
