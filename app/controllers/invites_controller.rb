class InvitesController < ApplicationController
  def new
  end

  #def create #this no longer necessary
  #	user = User.find_by_login(params[:login])
  #  user.send_email_verification if user
  #	sign_out
  #  redirect_to root_url, :notice => "An e-mail has been sent to verify your e-mail address. Click the link in the e-mail sent to you to finish signing up!"
  #end

  def edit
  	@user = User.find_by_invite_token!(params[:id])
  end

  def update
  	@user = User.find_by_invite_token!(params[:id])
    #if @user.invite_sent_at < 2.days.ago #does this make sense? I'm not going to worry about this right now. later deal! security issue! deal with soon!
    #  redirect_to new_invite_path, :alert => "Your link has expired. Send yourself another one!"
    if @user.update_attributes(params[:user])
      sign_in @user
  		redirect_to self_path, :notice => "Your account is now up and running! Read your story below, and update your picture in Settings!"
      ##@user.send_signup_confirmation
      ConfirmationsWorker.perform_async(@user.id)
  	else
  		#redirect_to about_path
      render :edit
  	end
  end
end
