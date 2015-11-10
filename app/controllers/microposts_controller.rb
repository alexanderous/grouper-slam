class MicropostsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user, only: [:destroy, :edit, :update]
  before_filter :authorized_user, only: :show

  def index
    if current_user.dead?
        sign_in current_user.admin
    end 
    @drafts = Micropost.where(:draft => true, :user_id => current_user.id)
    @newpublished = Micropost.where(:draft => false, :user_id => current_user.id) 
    @oldpublished = Micropost.where(:draft => nil, :user_id => current_user.id)
    @published = @newpublished + @oldpublished
    @user = current_user
    #@micropost = current_user.paginate(page: params[:page])
  end

  #def show
     #@user = User.find(params[:id])
     #@micropost = current_user.microposts.find(params[:id])
  #   @micropost = Micropost.find(params[:id]) #both this one and the one directly above seem to work...
  #   @comment = @micropost.comments.all
  #   @anthology_item = @micropost
     #@user = Micropost.where(:subject_id => @user.id)
     #@user = current_user
     #@subject = User.where(user.id => @micropost.subject_id)
  #end

  def show #_comments
     session[:return_to] = request.referer
     @micropost = Micropost.find(params[:id])
     @anthology_item = Micropost.find(params[:id])
     @comment = @anthology_item.comments.all
     #@love = @anthology_item.loves.all
     #@feed_item = Micropost.find(params[:id])
     #@comment.destroy
     #redirect_to @micropost
     @user = current_user
     @lovers = @anthology_item.lovers
     @users = User.search(params[:search], params[:page])
     ##@lovers = @anthology_item.loves
  end

     # def destroy
     # @comment = current_user.comments.find(params[:id])
     # @micropost = Micropost.find(params[:id]) # before, it was :article_id -- I don't know why??
     # @comment.destroy
     #   redirect_to @micropost
    #end

  def new
    if current_user.dead?
        sign_in current_user.admin
    end 
    ##@micropost = Micropost.new(key: params[])
    @micropost = current_user.microposts.build(params[:micropost])
    #@user = User.find(params[:id])

     #if @micropost.save
     # flash[:success] = "Story published!"
     # render 'microposts/show'
     #else
     # render 'shared/error_messages'
    #end
  end

  def create
    @micropost = current_user.microposts.build(params[:micropost])  
    if params[:draft_button]
      @micropost.update_attributes(:draft => true) 
      @micropost.save
      flash[:success] = "Story saved as draft!"
      redirect_to stories_and_drafts_path
    elsif params[:publish_button] #@micropost.save 
      @micropost.update_attributes(:draft => false)
      @micropost.update_attributes(:created_at => Time.now) 
      @micropost.save
      flash[:success] = "Story published!"
      @subject = @micropost.subject
      @anthology_items = Micropost.where(:subject_id => @subject.id)
      #redirect_to :back
      redirect_to micropost_path(@micropost)
      if !@subject.dead? && @anthology_items.count < 2
          @inviter = current_user #i think this is useless...
          ##@subject.send_invite
          #UserMailer.send_invite(@micropost.id) ## to test in development mode
          InvitationsWorker.perform_async(@micropost.id)
      elsif !@subject.dead? && @anthology_items.count > 1 #&& @subject.login != blank
          #@subject.send_notify
          ##UserMailer.notify(@micropost.id).deliver ## to test in development mode
          NotificationsWorker.perform_async(@micropost.id)
      #else
        #notify admin of the legacy anthology
      #elsif !@subject.dead && @anthology_items.count > 1 && @subject.logn != blank 

      end
      #if !@micropost.user.friend_with? @subject
      #  @micropost.hide = true #not working yet
      #end
    else
      redirect_to contribute_path
      #@anthology_items = [] #I changed this from @feed_items, although I'm not sure if I should have...
      #@object = @micropost
      #render 'microposts/micropost_errors'
    end
  end

  def edit
     @micropost = Micropost.find(params[:id])   
     #session[:return_to] = request.referer ## Website would crash when I submitted edit of micropost after coming from comments page. 
  end
  


  def update
    @micropost = Micropost.find(params[:id])
    if params[:draft_button]
      @micropost.update_attributes(params[:micropost])
      @micropost.update_attributes(:draft => true) 
      flash[:success] = "Story saved as draft!"
      redirect_to stories_and_drafts_path 
    elsif @micropost.update_attributes(params[:micropost])
      @micropost.update_attributes(:draft => false) 
      flash[:success] ='Story was successfully edited.' 
      @subject_id = @micropost.subject_id
      redirect_to @micropost
    else
      render 'edit'
    end
  end

  def destroy
    @micropost = Micropost.find(params[:id])
    @micropost.destroy
    flash[:success] ='Story was scrapped.' 
    #redirect_to session[:return_to] ||= root_path
    redirect_to root_path
  end

  def loving?(micropost)
    loves.find_by_loved_id(micropost.id)
  end

  def love!(micropost)
    loves.create!(loved_id: micropost.id)
  end

  def unlove!(micropost)
    loves.find_by_loved_id(micropost.id).destroy
  end
#  def loving?(micropost)
#    loves.find_by_loved_id(@micropost.id)
#  end

#  def love!
#    loves.create!
#  end
    
  def lovers
    @title = "Lovers"
    @micropost = Micropost.find(params[:id])
    @users = @micropost.lovers
    render 'show_lovers'
  end

  #def show_lovers
  #  @anthology_item = Micropost.find(params[:id])
  #  @micropost = Micropost.find(params[:id])
  #  @users = @micropost.lovers

  #end

  #def bid
  #  bid = current_user.loves.new(value: params[:value], micropost_id: params[:id])
  #  if bid.save
  #    redirect_to :back, notice: "Thanks for the kudos!"
  #  else
  #    redirect_to :back, alert: "Something went wrong, perhaps you've already given this story kudos!"
  #  end
  #end

  private

    def correct_user
         Micropost.find(params[:id]).user_id && Micropost.find(params[:id]).subject_id
         if !Micropost.find(params[:id]).subject.nil?
            if Micropost.find(params[:id]).subject.dead? 
              Micropost.find(params[:id]).subject.admin_id
            end
         end
    end
         #should this just be user and subject, not user_id and subject_id?
      #microposts.find
      #@micropost = current_user.microposts.find_by_id(params[:id]) && current_user.microposts.find_by_id(params[:subject_id]) #before, && was ||
      #redirect_to root_path if @micropost.nil?

    def authorized_user
      redirect_to root_path unless current_user?(Micropost.find(params[:id]).user) or current_user?(Micropost.find(params[:id]).subject) or current_user.friend_with?(Micropost.find(params[:id]).subject) or current_user.friend_with?(Micropost.find(params[:id]).user)
    end

end