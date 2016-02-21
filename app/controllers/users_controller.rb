class UsersController < ApplicationController
  include UsersHelper, MailHelper

  before_filter :signed_in_user, only: [:index, :show, :edit, :update, :destroy, :following, :followers]
  before_filter :signed_out_user, only: [:forgotten_password, :send_password_link, :show_reset_password, :reset_password]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
    respond_to do |format|
      format.html
      format.json {render json: @users}
    end
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
    @codeword = Codeword.new
  end

  def create
    @user = User.new(user_params)
    @codeword = Codeword.new(codeword_param)
    if @user.valid? & existing_codeword?(@codeword)
      @user.save
      sign_in @user
      flash[:success] = 'Welcome to TwittoSocial!'
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      sign_in @user
      flash[:success] = 'User was updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User deleted'
    redirect_to users_path
  end

  def forgotten_password
  end

  def send_password_link
    user = User.find_by_email(params[:user][:email].downcase)
    if user
      token = SecureRandom.urlsafe_base64
      user.update_attribute(:forgotten_password_key, token)
      send_forgot_password_message(user.email, token)
      flash[:success] = 'Check your email'
      redirect_to signin_path
    else
      flash.now[:error] = 'Email not found'
      render 'forgotten_password'
    end
  end

  def show_reset_password
    @user = User.find_by_forgotten_password_key(params[:uuid])
    if @user.nil?
      flash[:error] = 'Usertoken could not be found. Try resending the password for your user'
      redirect_to forgotten_password_path
    end
  end

  def reset_password
    @user = User.find_by_forgotten_password_key(params[:forgotten_password_key]) if params[:forgotten_password_key]
    if @user
      if @user.update_attributes(params[:user])
        @user.update_attribute(:forgotten_password_key, nil)
        sign_in @user
        flash[:success] = 'New password was set. Welcome inside!'
        redirect_to root_path
      else
        render 'show_reset_password'
      end
    else
      flash[:error] = 'Usertoken could not be found.'
      render 'forgotten_password'
    end
  end

  def following
    @title = 'Following'
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = 'Followers'
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path unless current_user?(@user)
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  private

  def user_params
    params.require(:user).permit(:name, :username, :email, :password, :password_confirmation)
  end

  def codeword_param
    params.require(:codeword).permit(:codeword)
  end

end
