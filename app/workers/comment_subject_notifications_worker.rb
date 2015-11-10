class CommentSubjectNotificationsWorker
	include Sidekiq::Worker
	sidekiq_options queue: "default"
	sidekiq_options :retry => 5

	def perform(comment_id)
	  perspective = Comment.find(comment_id)
	  anthology_item = perspective.micropost
	  #deliverer = anthology_item.user
	  deliveree = anthology_item.subject
	  deliveree.send_comment_subject_notify(comment_id) #normally @subject.send_notify #usually no paren at all
	end
end