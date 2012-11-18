class Group < ActiveRecord::Base
  attr_accessible :details, :name

  has_many :group_memberships, foreign_key: "group_id", dependent: :destroy
  has_many :members, through: :group_memberships

  has_many :activity_group_relations, foreign_key: "group_id", dependent: :destroy
  has_many :activitits, through: :activity_group_relations

  validates :name, 			presence: true
  validates :creator_id, 	presence: true
end
