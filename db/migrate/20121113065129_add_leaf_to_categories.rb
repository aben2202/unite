class AddLeafToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :leaf, :boolean
  end
end
