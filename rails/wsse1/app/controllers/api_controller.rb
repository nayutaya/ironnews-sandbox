
require "wsse/username_token_parser" # nayutaya-wsse
require "wsse/username_token_builder" # nayutaya-wsse

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
      username = "foo"
      password = "bar"

      parsed_token = Wsse::UsernameTokenParser.parse(wsse)
      wsse_username = parsed_token["Username"]
      wsse_nonce    = parsed_token["Nonce"]
      wsse_digest   = parsed_token["PasswordDigest"]
      wsse_created  = parsed_token["Created"]

      # FIXME: createdの範囲を限定
      # FIXME: リピート攻撃に対処

      generated_token = Wsse::UsernameTokenBuilder.create_token_params(username, password, wsse_nonce.unpack("m")[0], wsse_created)
      digest = generated_token["PasswordDigest"]

      if wsse_username == username && wsse_digest == digest
        return true
      end
    end

    render(:text => "authentication failed")
    return false
  end
end
