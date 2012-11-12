class GenericActivity < ActiveRecord::Base
  attr_accessible :category_id, :image_path, :name

  validates :name,			presence: true
  validates :category_id, 	presence: true
end
