class Comment < ActiveRecord::Base
  attr_accessible :activity_id, :user_id, :title, :body

  belongs_to :activity
  belongs_to :user

  validates :activity_id, 	presence: true
  validates :user_id, 		presence: true
end 
