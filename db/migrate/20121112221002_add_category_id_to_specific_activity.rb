class AddCategoryIdToSpecificActivity < ActiveRecord::Migration
  def change
    add_column :specific_activities, :category_id, :integer
  end
end
