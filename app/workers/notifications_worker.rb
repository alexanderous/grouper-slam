class NotificationsWorker
	include Sidekiq::Worker
	sidekiq_options queue: "default"
	sidekiq_options :retry => 5

	def perform(micropost_id)
	  anthology_item = Micropost.find(micropost_id)
	  #deliverer = anthology_item.user
	  deliveree = anthology_item.subject
	  deliveree.send_notify(micropost_id) #normally @subject.send_notify #usually no paren at all
	  #deliveree.send_notify
	  #deliveree.send_notify(anthology_item)
	end
end