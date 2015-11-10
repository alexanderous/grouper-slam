class LovesController < ApplicationController
  before_filter :signed_in_user

  def create
  	@micropost = Micropost.find(params[:love][:loved_id])
  	##@anthology_item = Micropost.find(params[:love][:loved_id])
  	#@anthology_item = Micropost.find(params[:micropost_id])
    #@micropost = Micropost.find(params[:micropost_id])
  	        #@anthology_item = Micropost.find(params[:micropost_id])
  	#@love = @micropost.loves.build(params[:comment])
  	#@love.user = current_user
    #@love = @micropost.loves.build(params[:love])
  	current_user.love!(@micropost)
  	#redirect_to :back
  	respond_to do |format|
  		format.html { redirect_to @micropost }
  		format.js { render :layout=>false, :content_type => 'application/javascript' }
  	end
  end

  def destroy
  	@micropost = Love.find(params[:id]).loved
  	current_user.unlove!(@micropost)
  	#redirect_to @micropost
  	respond_to do |format|
  		format.html { redirect_to :back }
  		format.js { render :layout=>false, :content_type => 'application/javascript' }
  	end
  end
end
