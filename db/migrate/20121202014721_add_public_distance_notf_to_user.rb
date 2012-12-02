class AddPublicDistanceNotfToUser < ActiveRecord::Migration
  def change
    add_column :users, :public_distance_notf_max, :integer
  end
end
