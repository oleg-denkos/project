class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable, :lockable
  has_many :comments, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :rates, dependent: :destroy
  
  update_index('posts#post'){ posts }

  acts_as_liker

  validates :username, :email, presence: true
  validates :username, :email, uniqueness: true


end
