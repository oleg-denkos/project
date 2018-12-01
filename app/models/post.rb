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

	searchable do
		text :title, :body, :description, boost: 5.0
		integer :spec
		text :tag_list do
			tag_list.map { |tag| tag}
		end
		text :comments do
			comments.map { |comment| comment.body }
		end
		string  :sort_title do
			title.downcase.gsub(/^(an?|the)/, '')
		end
	end
	
	self.per_page = 10
	
end

