class Post < ApplicationRecord
	belongs_to :user

	has_many :rates, dependent: :destroy
	has_many :comments, dependent: :destroy
	

	validates :title, :body, :description, :spec, :tag_list, presence: true
 	validates :spec, numericality: { only_integer: true }
 	validates :title, uniqueness: { scope: :user_id,
    message: "You have already created an abstract with this title." }

	acts_as_taggable
	include ActsAsTaggableOn::TagsHelper
	
	update_index('posts#post') { self }
	self.per_page = 10
	
end

