 class UserMailer < ActionMailer::Base
  default from: "admin@antho.co"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    attachments.inline['Anthologowhite.jpg'] = File.read('app/assets/images/Anthologowhite.jpg')
    mail :to => @user.email, :subject => "Password Reset"
  end

  #def signup_confirmation(user)
  #  @user = user
  #  mail to: user.email, subject: "Welcome to Antho!"
  #end

  def notify(micropost_id)
    @anthology_item = Micropost.find(micropost_id)
    @user = @anthology_item.subject
    @author = @anthology_item.user
    attachments.inline['Anthologowhite.jpg'] = File.read('app/assets/images/Anthologowhite.jpg')
    mail :to => @user.email, subject: "#{@author.name} just contributed to your life story on Antho!"
  end

  def comment_author_notify(comment_id) 
    @perspective = Comment.find(comment_id)
    @anthology_item = @perspective.micropost
    @user = @anthology_item.user
    @author = @perspective.user
    attachments.inline['Anthologowhite.jpg'] = File.read('app/assets/images/Anthologowhite.jpg')
    mail :to => @user.email, :subject => "#{@author.name} just commented on a story of yours on Antho!"
  end

  def comment_subject_notify(comment_id) 
    @perspective = Comment.find(comment_id)
    @anthology_item = @perspective.micropost
    @user = @anthology_item.subject
    @author = @perspective.user
    attachments.inline['Anthologowhite.jpg'] = File.read('app/assets/images/Anthologowhite.jpg')
    mail :to => @user.email, :subject => "#{@author.name} just commented on a story of yours on Antho!"
  end

  def email_verification(user) #not in use right now; we skipped this step
    @user = user
    attachments.inline['Anthologowhite.jpg'] = File.read('app/assets/images/Anthologowhite.jpg')
    mail :to => user.email, :subject => "Please verify your e-mail."
  end

  def invite(user)
    @user = user
    attachments.inline['Anthologowhite.jpg'] = File.read('app/assets/images/Anthologowhite.jpg')
    attachments.inline['bridge.jpg'] = File.read('app/assets/images/bridge.jpg')
    attachments.inline['computer.jpg'] = File.read('app/assets/images/computer.jpg')
    attachments.inline['keys.jpg'] = File.read('app/assets/images/keys.jpg')
    attachments.inline['medal.jpg'] = File.read('app/assets/images/medal.jpg')
    attachments.inline['oblivion.jpg'] = File.read('app/assets/images/oblivion.jpg')
    attachments.inline['puzzpiece.jpg'] = File.read('app/assets/images/puzzpiece.jpg')
    mail :to => @user.email, subject: "#{@user.admin.name} has invited you to try out Antho!"
  end
  
  def signup_confirmation(user)
    @user = user
    attachments.inline['Anthologowhite.jpg'] = File.read('app/assets/images/Anthologowhite.jpg')    
    mail :to => @user.email, subject: "Welcome to Antho!"
  end

end
