class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_login(params[:session][:login])
    if user && user.authenticate(params[:session][:password])   
      sign_in user
      if user.microposts.count < 5
        flash[:success] = "Hey there! Check out some of the most recent stories of your kin here at the Museum!"
        redirect_to root_path
      elsif user.friends.count < 5 
        flash[:success] = "Welcome Back! Explore the collection of anthologies and add some kin, or start an anthology for someone new!"
        redirect_to anthologies_path
      else
        redirect_to root_path
      end
    else
      flash.now[:error] = "Sorry, but either your username or password is wrong! Your username is case-sensitive."
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
