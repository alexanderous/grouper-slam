class SubjectsController < ApplicationController
	def index
	  @subjects = User.order(:name).where("name like ?", "%#{params[:term]}%")
	  render json: @subjects.map(&:name)
	end
end
