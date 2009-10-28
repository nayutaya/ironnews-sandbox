
class ApiController < ApplicationController
  before_filter :authentication, :only => [:go]

  def go
    render(:text => "ok")
  end

  private

  def authentication
    user_id = session[:user_id]

    if !user_id.nil?
      return true
    else
    end

    render(:text => "authentication failed")
    return false
  end
end
