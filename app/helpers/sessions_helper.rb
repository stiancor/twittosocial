module SessionsHelper
  include ApplicationHelper

  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user?(user)
    current_user == user
  end

  def sign_out
    self.current_user = nil
    cookies.delete :remember_token
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to]||default)
    session.delete(:return_to)
  end

  def signed_out_user
    if signed_in?
      redirect_to root_path, notice: 'Already signed in.'
    end
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_path, notice: 'Please sign in.'
    end
    @user_rank = calculate_user_rank
  end
end


