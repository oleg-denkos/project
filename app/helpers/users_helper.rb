module UsersHelper
		def sortable(column, title = nil)
		title.to_s ||= column.to_s
		direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
		link_to title, :sort => column, :direction => direction
	end
end
