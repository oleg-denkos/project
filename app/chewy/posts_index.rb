class PostsIndex < Chewy::Index 
	define_type Post.includes(:comments, :user, :tags) do 
		field :title, :description 
		field :body, type: 'text' 
		field :spec, type: 'integer'
		field :comments, value: ->(post) { post.comments.map(&:body)} 
		field :user, value: ->(post) {post.user.username} 
		field :tags, value: ->(post) { post.tags.map(&:name)} 
	end 
end
