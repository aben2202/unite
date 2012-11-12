class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,  #added by devise
  				  :first_name, :last_name, :username, :age, :zipcode		#general info
  				 

  # has_many :subscriptions
  # has_many :activities, through: :subscriptions

  #validations
  validates :username,  			presence: true
  validates :age,       			presence: true
  validates :zipcode,   			presence: true

  # attr_accessible :title, :body
end
