class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie

  # render new.rhtml
  def new
  end

  def signup
    puts"signin up.."+params.to_s
 
    @user = User.new(params[:user])
    
    return unless request.post?
    @user.apiKey=@user.getKey
    @user.save!
    self.current_user = @user
    
    Notifier.deliver_apikey_notification(@user)
    
    redirect_back_or_default(:controller => '/users', :action => 'apiSend')
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    flash[:notice] = "Invalid username/password!"
    render :action => 'signup'
  end
  
  def apiSend
  end
  
  def create
    @user = User.new(params[:user])
    @user.save!
    self.current_user = @user
    redirect_back_or_default('/')
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end
def staticShow
		render(:action=>params[:id])
end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = 'User was successfully created.'
      render :text=>"ok"
    else
      puts "error.."
      render :action => 'signup'
    end
  end
end
