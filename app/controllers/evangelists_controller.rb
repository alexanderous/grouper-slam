class EvangelistsController < ApplicationController
  #before_filter :admin_user,     only: :index

  #def self.search(search, page)
      #find(:all, :conditions => ['name ILIKE ?', "%#{search}%"])

  #    paginate :per_page => 16, :page => page,
  #              :conditions => ['name ILIKE ?', "%#{search}%"], :order => 'name'
    
  #end  

  def index
  	#@evangelists = Evangelist.all
    @evangelists = Evangelist.all
    #search(params[:search], params[:page])

  end

  def new
  	@evangelist = Evangelist.new(params[:evangelist])
  end

  def create
    @evangelist = Evangelist.new(params[:evangelist])
    if @evangelist.save
      flash[:success] = "Thanks for requesting an invite! We'll get you access as soon as possible!"
      redirect_to root_url
    else
      render 'new'
    end
    
  end

end
