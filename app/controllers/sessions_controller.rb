class SessionsController < ApplicationController
  def new
  end

  def create   
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      log_in user
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render :new, status: 422
    end
  end

  def destroy
    log_out
    redirect_to root_url, status: 303
  end
end
