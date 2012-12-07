class AddPublicOptionToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :open_to_public, :boolean, default: true
  end
end
