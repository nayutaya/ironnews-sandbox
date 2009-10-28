
class HomeController < ApplicationController
  def index
  end

  def login
    flash[:notice] = "ログインしました。"
    redirect_to(:action => "index")
  end

  def logout
    flash[:notice] = "ログアウトしました。"
    redirect_to(:action => "index")
  end
end
