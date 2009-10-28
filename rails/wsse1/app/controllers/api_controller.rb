
class ApiController < ApplicationController
  before_filter :authentication, :only => [:go]

  def go
    render(:text => "ok")
  end

  private

  def authentication
    user_id = session[:user_id]
    wsse    = request.env["HTTP_X_WSSE"]
p wsse
#p request.user_agent
#p request.env

    if !user_id.blank?
      return true
    elsif !wsse.blank?
      return true
    end

    render(:text => "authentication failed")
    return false
  end
end
