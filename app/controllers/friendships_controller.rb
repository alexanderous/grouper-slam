class FriendshipsController < ApplicationController

  #before_filter :authenticate_user
  
  #def index
  #  if current_user.dead?
  #      sign_in current_user.admin
  #  end 
  #  @friends = current_user.friends
  #  #@friends = pending_invited_by 
  #  #@requesting_friends = User.all
  #  @pending_requests = current_user.pending_invited_by
  #  @user = current_user
  #  @users = User.search(params[:search], params[:page])
  #end

#  def other_user_index
#    @user = User.find_by_id(params[:id])
#    @friends = @user.friends
#    @common_friends = @user.common_friends_with current_user
#  end


  def new
    @users = User.all :conditions => ["id != ?", current_user.id]
  end

  def create
    invitee = User.find_by_id(params[:user_id])
    if current_user.invite invitee
      redirect_to :back, :notice => "Kinship requested."
    else
      redirect_to :back, :notice => "Sorry! You can't request kinship with that individual!"
    end
  end

  def update
    inviter = User.find_by_id(params[:id])
    @user = User.find(params[:id])
    @admin = @user.admin
    #
    #if @user.dead?
    #  sign_in @user
    #  if current_user.approve inviter
    #    sign_in current_user
    #    redirect_to :back, :notice => "Kinship was confirmed."
    #  else
    #    sign_in current_user
    #    redirect_to :back, :notice => "Sorry, couldn't confirm kinship. Please try again later."   
    #  end
    #end
#
    if current_user.approve inviter
      redirect_to :back, :notice => "Kinship was confirmed."
    #elsif @admin.approve inviter 
    #  redirect_to :back, :notice => "Kinship was confirmed."
    else
      redirect_to :back, :notice => "Sorry, couldn't confirm kinship. Please try again later." 
    end
  end
  
  def requests
    @pending_requests = current_user.pending_invited_by
  end
  
  def invites
    @pending_invites = current_user.pending_invited
  end

  def destroy
    user = User.find_by_id(params[:id])
    if current_user.remove_friendship user
      redirect_to :back, :notice => "Kinship was dissolved."
    else
      redirect_to :back, :notice => "Sorry, couldn't dissolve kinship. Please try again later."
    end
  end 
end
