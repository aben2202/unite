class Group < ActiveRecord::Base
  attr_accessible :details, :name

  has_many :group_memberships, foreign_key: "group_id"
  has_many :members, through: :group_memberships

  belongs_to :activity

  validates :name, 			presence: true
  validates :creator_id, 	presence: true
end
