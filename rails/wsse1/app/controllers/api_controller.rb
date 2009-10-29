
class ApiController < ApplicationController
  before_filter :authentication, :only => [:go]

  def go
    render(:text => "ok")
  end

  private

  def authentication
    user_id = session[:user_id]
    wsse    = request.env["HTTP_X_WSSE"]

    if !user_id.blank?
      return true
    elsif !wsse.blank?
      # FIXME: createdの範囲を限定
      # FIXME: リピート攻撃に対処
      token = Wsse::UsernameToken.parse(wsse)
      if token
        username = "foo"
        password = "bar"
        if Wsse::Authenticator.authenticate?(token, username, password)
          return true
        end
      end
    end

    render(:text => "authentication failed")
    return false
  end
end
