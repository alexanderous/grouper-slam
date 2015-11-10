class UsersController < ApplicationController
  before_filter :signed_in_user#,
                #only: [:new, :create, :index, :edit, :update, :destroy, :following, :followers, :show, :show_posts, :other_user_index, :story_ticker, :kinships]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy
  before_filter :kin,         only: [:show_posts, :anthologies_managed]

  def index
    #@users = User.paginate(page: params[:page])
    @users = User.search(params[:search], params[:page])
    #@users = User.order("name").page(params[:page]).per_page(5) #search function from Railscasts
    session[:return_to] = request.referer
    #common_friends_with = @user.friends == current_user.friends
    #possible_friends = common_friends_with(@user)
    #@possible_friends = current_user.possible_friends
    if current_user.dead?
        sign_in current_user.admin
        redirect_to anthologies_path
    end 
    #@users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @users = User.search(params[:search], params[:page])
    if current_user.dead?
        sign_in current_user.admin
        redirect_to user_path(@user)
    end 
    @micropost = current_user.microposts.build
    @microposts = @user.microposts
    @drafts = Micropost.where(:user_id => @user.id, :draft => true)
    @publishedcontributions = @user.microposts - @drafts
    @comment_items = Comment.where(:user_id => @user.id)
    @comments = @micropost.comments.all
    @anthology_items = Micropost.where(:subject_id => @user.id).reorder('dateofevent')
    session[:return_to] = request.referer
    @admin = @user.admin
    @legacy_anthologies = @user.legacy_anthologies.where(:dead => true)
  end



  def show_posts 
    @user = User.find(params[:id])
    @users = User.search(params[:search], params[:page])
    @micropost = current_user.microposts.build
    @microposts = @user.microposts.reorder('dateofevent')
    @anthology_items = Micropost.where(:subject_id => @user.id)
    session[:return_to] = request.referer
    @hidden_contributions = current_user.microposts.where(:hide => "true")
  end

  #def hidden_posts
  #  @user = current_user
  #  @anthology_items = Micropost.where(:subject_id => @user.id)
  #  @hidden_posts = @anthology_items.where(:hide => "true")  
  #end

  #def hidden_contributions
  #  @user = current_user
  #  @hidden_contributions = @user.microposts.where(:hide => "true")
  #end

  #def story_ticker
  #  @feed_items = current_user.feed.paginate(:page => params[:page])
  #end

  def new
    if current_user.dead?
        sign_in current_user.admin
    end 
    @user = User.new
    @users = User.search(params[:search], params[:page])
  end
  
  def create
    @user = User.new(params[:user])
    if @user.email == "" && @user.dead
      @user.email = "legacy@antho.co"
    end
    if @user.save
      #UserMailer.invite(@user).deliver
      #UserMailer.signup_confirmation(@user).deliver
      #sign_in @user
      #use this to make first and last names!! @user.first_name, @user.last_name = params[:user][:full_name].split(" ", 2)
      current_user.invite(@user)
      @user.approve(current_user)
      if @user.dead?
        flash[:success] = "Thanks for creating an anthology! As this anthology's creator, you will manage its posts and kinships."
      else
        flash[:success] = "Thanks for creating an anthology! An e-mail will be sent to your friend when you contribute your first story!"
      end
      redirect_to @user
    else
      render 'new'
    end
  end

  #def change_password
  #  @user = current_user
  #end

  def edit
    @user = User.find(params[:id])
    @users = User.search(params[:search], params[:page])
    if @user.dead? && current_user == @user
        sign_in @user.admin
        redirect_to edit_user_path(@user.admin)
    end 
  end

  def update
    @user = User.find(params[:id])
    #currently a security hole; if ppl leave accounts signed in at public computers
    #people can change their e-mail addresses/pwds without needing to know their current pwd
    #but at least for now people can update photo without entering old or new password
    #need to have new variable called current password -- perhaps use devise/omniauth for greater security
    #below, attempt at hijacking devise methods for users to require inputting pwd when updating email address,
    #but since it doesn't require current password, it's worthless right now.
    #email_changed = @user.email != params[:user][:email]
    #password_changed = !params[:user][:password].empty?
    #successfully_updated = if email_changed or password_changed
          #@user.update_with_password(params[:user])
      #  sign_in @user
      #  flash[:success] = "Information updated"
      #  redirect_to @user
      #else
      #  render 'edit'
      #end
   
   
    if @user.update_attributes(params[:user])
      if @user.dead?
        flash[:success] = "Information updated"
        redirect_to @user
      else 
        sign_in @user
        flash[:success] = "Information updated"
        redirect_to @user
      end
    else
      render 'edit'
    end

  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_path
  end

  def anthologies_managed
    @user = User.find(params[:id])
    #@user = current_user
    @legacy_anthologies = @user.legacy_anthologies.where(:dead => "true")
    @users = User.search(params[:search], params[:page])
  end



  def self
      @user = current_user
      @users = User.search(params[:search], params[:page])
      if @user.dead?
        sign_in @user.admin
        redirect_to self_path
      end 
      @micropost = current_user.microposts.build
      @drafts = Micropost.where(:user_id => @user.id, :draft => true)
      @publishedcontributions = @user.microposts - @drafts
      @comments = @micropost.comments.all #change back to @micropost same with last item
      @anthology = current_user.anthology
      @anthology_items = @user.anthology
      @comment_items = @micropost.comments.all
      @legacy_anthologies = @user.legacy_anthologies.where(:dead => true)
  end

  def kinships
    @user = User.find(params[:id])
    if @user.dead && current_user == @user.admin
      sign_in @user
      redirect_to kinships_user_path(@user)
    elsif current_user.dead && @user != current_user
      sign_in current_user.admin
      redirect_to kinships_user_path(@user)
    end 
    @users = User.search(params[:search], params[:page])

    #if @user.dead? && current_user == @user.admin
    #  sign_in @user
    #  redirect_to kinships_user_path(@user) 
    #end
    @friends = @user.friends
    @pending_requests = @user.pending_invited_by

#    if @pending_requests === current_user
#      sign_in @user
#    else
#      sign_in current_user
#    end
  end

  #def following
  #  @title = "Following"
  #  @user = User.find(params[:id])
  #  @users = @user.followed_users.paginate(page: params[:page])
  #  render 'show_follow'
  #end

  #def followers
  #  @title = "Followers"
  #  @user = User.find(params[:id])
  #  @users = @user.followers.paginate(page: params[:page])
  #  render 'show_follow'
  #end


  private

    def correct_user
      #@user ||= User.find(params[:id]) #did I substitute this line of code for that below bc of pseudo users? not sure...
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user) or current_user?(@user.admin)
    end

    def admin_user
      redirect_to root_path unless current_user.admin?
    end

    def kin
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user.friend_with?(@user) or current_user?(@user)
    end

end

