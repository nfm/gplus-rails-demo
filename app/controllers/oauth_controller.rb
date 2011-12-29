class OauthController < ApplicationController
  before_filter :setup_gplus

  def callback
    access_token = @gplus.authorize(params[:code])
    @user = User.new(
      :token => access_token.token,
      :refresh_token => access_token.refresh_token,
      :token_expires_at => access_token.expires_at
    )
    @user.save
    redirect_to @user
  end
end
