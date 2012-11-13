class Category < ActiveRecord::Base
  attr_accessible :name, :image_path, :parent_category_id, :leaf

  #validations
  validates :name, presence: true, uniqueness: true

end
