class StaticPagesController < ApplicationController
  #before_filter :authenticate

  def home
    if signed_in?
      @feed_items = current_user.feed.paginate(:page => params[:page]) #feed! #does this limit it to 30 posts?
      @users = User.search(params[:search], params[:page])
      #anthology_item = Micropost.find(params[:id])
         # @users = @user.followers.paginate(page: params[:page])
      if current_user.dead?
        sign_in current_user.admin
        redirect_to root_path
      end
    end
  end



  def help
    @users = User.search(params[:search], params[:page])
  end

  def about
    @users = User.search(params[:search], params[:page])
  end

  protected

  #def authenticate
  #  authenticate_or_request_with_http_basic do |username, password|
  #    username == "alpha" && password == "hearts"
    #end
  #end
  # I commented the password out because people can't sign up anymore. This is a full-website password.
end
