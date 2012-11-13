class Activity < ActiveRecord::Base
  attr_accessible :title, :description, :its_on, :max_participants, :min_participants, :when, :category_id

  has_one :location

  validates :title,				presence: true
  validates :min_participants, 	presence: true
  validates :when,				presence: true
end
