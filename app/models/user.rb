class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
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

  def self.find_for_vkontakte_oauth access_token
    if user = User.where(:email => access_token.extra.raw_info.domain+'@vk.com').first
      user
    else 
      User.create!(:provider => access_token.provider,
        :uid => access_token.info.user_ids,
        :username => access_token.info.name,
        :email => access_token.extra.raw_info.domain+'@vk.com',
        :password => Devise.friendly_token[0,20]) 
      user.skip_confirmation!
      user.save
      user
    end
  end
end
