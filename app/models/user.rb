class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable, :omniauth_providers => [:facebook, :vkontakte],
  :recoverable, :rememberable, :validatable, :lockable, :confirmable

  has_many :comments, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :rates, dependent: :destroy
  
  update_index('posts#post'){ posts }

  acts_as_liker

  validates :username, :email, presence: true
  validates :username, :email, uniqueness: true

  def self.find_for_facebook_oauth(auth, signed_in_resource = nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first 

      return registered_user if registered_user

      user = User.new(
       username:auth.extra.raw_info.name,
       provider:auth.provider,
       uid:auth.uid,
       email:auth.info.email,
       password:Devise.friendly_token[0,20]
       )
      user.skip_confirmation!
      user.save
      user
    end
  end

  def self.from_omniauth_vk(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.username = auth.info.name
    end
  end
  end 
end
