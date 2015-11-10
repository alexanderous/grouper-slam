class CommentsController < ApplicationController
	before_filter :signed_in_user
    before_filter :correct_user, only: [:destroy]
    before_filter :kin_user, only: :show
    #def new
    #    session[:return_to] = request.referer
    #end

	def create
        session[:return_to] ||= request.referer
        @anthology_item = Micropost.find(params[:micropost_id])
    	@micropost = Micropost.find(params[:micropost_id])
		@comment = @micropost.comments.build(params[:comment])
		@comment.user = current_user

		if @comment.save
      		flash[:success] = "Comment published!"
      		##redirect_to :back

            #redirect_to root_path
            ##redirect_to session[:return_to]
            if current_user != @micropost.user
                #UserMailer.comment_author_notify(@comment.id).deliver ## to test in development mode
                CommentAuthorNotificationsWorker.perform_async(@comment.id)
            end
            if current_user != @micropost.subject && !@micropost.subject.dead?
                #UserMailer.comment_subject_notify(@comment.id).deliver ## to test in development mode
                CommentSubjectNotificationsWorker.perform_async(@comment.id)
            end
            render 'comments/index'
   		else
            render 'comments/index'
        end

    end

    def show
    end

    def index
        #@user = User.find(params[:id])
        @user = current_user
        #@micropost = current_user.microposts.find(params[:id])
        @micropost = Micropost.find(params[:micropost_id])
        @fans = @micropost.lovers.all
        @users = User.search(params[:search], params[:page]) 
        #@comment = @micropost.comments.all
        #@micropost = Micropost.find(params[:id])
        #@anthology_item = Micropost.find(params[:id])
        #@comment = @anthology_item.comments.all

    end

    def destroy
    	@comment = current_user.comments.find(params[:id])
    	@micropost = Micropost.find(params[:id]) # before, it was :article_id -- I don't know why??
    	@comment.destroy
        redirect_to @micropost
    end
    	
    #def index
    #    @user = current_user
    #    @micropost = current_user.microposts.build
    #    @microposts = @user.microposts
    #    @anthology_items = Micropost.where(:subject_id => @user.id)
    #end

    private

        def correct_user
             Comment.find(params[:id]).user_id && Micropost.find(params[:id]).subject_id && Micropost.find(params[:id]).user_id && User.where(:admin => "true")
          #if this doesn't work, try user and subject (without the _id)
          #microposts.find
          #@micropost = current_user.microposts.find_by_id(params[:id]) && current_user.microposts.find_by_id(params[:subject_id]) #before, && was ||
          #redirect_to root_path if @micropost.nil?
        end

        def kin_user
            redirect_to(root_path) unless redirect_to root_path unless current_user?(Micropost.find(params[:id]).user) or current_user?(Micropost.find(params[:id]).subject) or current_user.friend_with?(Micropost.find(params[:id]).subject) or current_user.friend_with?(Micropost.find(params[:id]).user)
        end  
end
