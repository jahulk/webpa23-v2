class SessionsController < ApplicationController
  def new
    # renderöi kirjautumissivun
  end

  def create
    user = User.find_by username: params[:username]
    if user.nil?
      redirect_to signin_path, notice: "User #{params[:username]} does not exist!"
    else
      session[:user_id] = user.id if !user.nil?
      redirect_to user, notice: "Welcome #{user.username}!"
    end
  end

  def destroy
    # nollataan sessio
    session[:user_id] = nil
    # uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end
end
