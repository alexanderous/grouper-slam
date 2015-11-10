module UsersHelper


  # these next three definitions come from sessions_helper
  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user?(user)
    user == current_user
  end

#  def micropost_relationships
#   @user ||= @current_user
#  end

end
