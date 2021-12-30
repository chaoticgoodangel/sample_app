class SessionsController < ApplicationController
  def new
  end
  
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    #Log the user in and redirect to the user's show page
    if @user && @user&.authenticate(params[:session][:password])
        flash[:success] = "Welcome to the Sample App!"
        forwarding_url = session[:forwarding_url]
        reset_session
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        log_in @user
        redirect_to forwarding_url || @user
    else
    #Create an error message
      flash.now[:danger] = 'Invalid email/password combination' #Not quite right
      render 'new'
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
