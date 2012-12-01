class Category < ActiveRecord::Base
  attr_accessible :name, :image_path, :parent_category_id, :leaf

  has_many :subscriptions, foreign_key: "category_id"
  has_many :subscribers, through: :subscriptions

  #validations
  validates :name, presence: true, uniqueness: true

end
