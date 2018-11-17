$ ->
  App.cable.subscriptions.create { channel: "CommentsChannel", id: $("meta[id=meta_post]").attr('post') },
  received: (data) -> 
  	$(comment_pane).append data
	
 