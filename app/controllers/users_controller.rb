class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :ensure_that_admin, only: %i[toggle_activity]
  before_action :ensure_that_signed_in, except: %i[new create]
  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if user_params[:username].nil? && (@user == current_user) && @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    if current_user == @user
      @user.destroy
      session[:user_id] = nil
    end

    redirect_to users_path, notice: "User was successfully destroyed."
    # respond_to do |format|
    #   format.html { redirect_to users_url, notice: "User was successfully destroyed." }
    #   format.json { head :no_content }
  end

  def toggle_activity
    user = User.find(params[:id])
    user.update_attribute :active, !user.active

    redirect_to users_path, notice: "User #{user.username} activity status changed to #{user.active}"
  end

  def recommendation
    ids = Beer.pluck(:id)
    random_beer = Beer.find(ids.sample)
    render partial: 'recommendation', locals: { beer: random_beer }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
