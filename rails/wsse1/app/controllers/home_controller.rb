
class HomeController < ApplicationController
  def index
  end

  def login
    session[:user_id] = 1
    flash[:notice] = "ログインしました。"
    redirect_to(:action => "index")
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました。"
    redirect_to(:action => "index")
  end
end
