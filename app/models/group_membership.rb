class GroupMembership < ActiveRecord::Base
  attr_accessible :group_id, :member_id

  belongs_to :member, class_name: "User"
  belongs_to :group

  validates :group_id, 	presence: true
  validates :member_id, presence: true
  validates_uniqueness_of :group_id, scope: :member_id
end
