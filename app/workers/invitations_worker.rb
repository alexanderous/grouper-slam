class InvitationsWorker
	include Sidekiq::Worker
	sidekiq_options queue: "default"
	sidekiq_options :retry => 5

	def perform(micropost_id)
	  anthology_item = Micropost.find(micropost_id)
	  deliveree = anthology_item.subject
	  deliveree.send_invite #normally @subject.send_invite
	end
end