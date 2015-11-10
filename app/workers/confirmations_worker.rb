class ConfirmationsWorker
	include Sidekiq::Worker
	sidekiq_options queue: "default"
	sidekiq_options :retry => 5

	def perform(user_id)
	  user = User.find(user_id)
	  deliveree = user
	  deliveree.send_signup_confirmation #normally @subject.send_invite
	end
end