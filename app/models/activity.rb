class Activity < ActiveRecord::Base
  attr_accessible :title, :description, :its_on, :max_participants, :min_participants, :when, :category_id

  has_one :location

  has_many :participations, foreign_key: "activity_id"
  has_many :users, through: :participations

  validates :title,				presence: true
  validates :min_participants, 	presence: true
  validates :when,				presence: true
end
