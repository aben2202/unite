class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,  #added by devise
  				  :first_name, :last_name, :username, :age, :zipcode		#general info
  				 

  has_many :participations, foreign_key: "user_id"
  has_many :activities, through: :participations

  #validations
  validates :username,  			presence: true
  validates :age,       			presence: true
  validates :zipcode,   			presence: true

  # attr_accessible :title, :body

  def participating?(activity)
    self.participations.find_by_activity_id(activity.id)
  end

  def participate!(activity)
    self.participations.create!(activity_id: activity.id)
  end

  def quit!(activity)
    self.participations.find_by_activity_id(activity.id).destroy
  end
end
