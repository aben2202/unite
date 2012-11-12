class CreateGenericActivities < ActiveRecord::Migration
  def change
    create_table :generic_activities do |t|
      t.string :name,			:null => false, :default => ""
      t.string :image_path		
      t.integer :category_id,	:null => false

      t.timestamps
    end
  end
end
