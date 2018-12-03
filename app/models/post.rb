class Post < ApplicationRecord
	belongs_to :user

	has_many :rates, dependent: :destroy
	has_many :comments, dependent: :destroy
	

	validates :title, :body, :description, :spec, :tag_list, presence: true
 	validates :spec, numericality: { only_integer: true }, length: { maximum: 50000 }
 	validates :title, uniqueness: { scope: :user_id },
    length: { minimum: 5 }
    validates :body, :description, length: { minimum: 10, maximum:200000 }

	acts_as_taggable
	include ActsAsTaggableOn::TagsHelper
	
	update_index('posts#post') { self }
	self.per_page = 10
	
end

