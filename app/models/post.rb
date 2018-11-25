class Post < ApplicationRecord
	
	has_many :comments, dependent: :destroy


	acts_as_taggable
	include ActsAsTaggableOn::TagsHelper

	filterrific(
		default_filter_params: { sorted_by: 'created_at_desc' },
		available_filters: [
			:sorted_by,
			:search_query,
			:with_title,
			:with_spec,
			:with_created_at_gte
		]
		)

	belongs_to :user
	self.per_page = 10

	scope :sorted_by, lambda { |sort_option|
		direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
		case sort_option.to_s
		when /^created_at_/
			order("post.created_at #{ direction }")
		when /^title_/
			order("LOWER(post.title) #{ direction }")
		when /^spec/
			order("LOWER(post.spec) #{ direction }")
		else
			raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
		end
	}

	scope :search_query, lambda { |query|
		return nil  if query.blank?

		terms = query.downcase.split(/\s+/)
		terms = terms.map { |e|
			(e.gsub('*', '%') + '%').gsub(/%+/, '%')
		}
		num_or_conds = 2
		where(
			terms.map { |term|
				"(LOWER(posts.title) LIKE ?)"
			}.join(' AND '),
			*terms.map { |e| [e] * num_or_conds }.flatten
			)}

		scope :with_title, lambda { |titles|
			where(:title => [*titles])
		}	
		scope :with_spec, lambda { |specs|
			where(:spec => [*specs])
		}
		scope :with_created_at, lambda { |ref_date|
			where('post.created_at => ?', Data.strptime(ref_date, "%m/%d/%Y"))
		}

		def self.options_for_sorted_by
			[
				['title (a-z)', 'title_asc'],
				['title (z-a)', 'title_desc'],
				['Created date (newest first)', 'created_at_desc'],
				['Created date (oldest first)', 'created_at_asc'],
				['spec (0-9)', 'spec_asc'],
				['spec (9-0)', 'spec_desc'],
			]
		end	
	end

