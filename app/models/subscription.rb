class Subscription < ActiveRecord::Base
  attr_accessible :category_id, :subscriber_id

  belongs_to :subscriber, class_name: "User"
  belongs_to :category

  validates :category_id, 	presence: true
  validates :subscriber_id,	presence: true
  validates_uniqueness_of :subscriber_id, scope: :category_id
end
