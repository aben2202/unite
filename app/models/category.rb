class Category < ActiveRecord::Base
  attr_accessible :name, :image_path, :parent_category_id

  #validations
  validates :name, presence: true

end
