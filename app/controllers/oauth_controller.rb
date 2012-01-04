class OauthController < ApplicationController
  before_filter :setup_gplus

  # Handle OAuth callbacks from Google+
  def callback
    # Take the short-lived :code, and use it to get a proper access_token from Google+
    access_token = @gplus.get_token(params[:code])

    # Store the access_token so that we can use it later to access the user's information
    @user = User.new(
      :token => access_token.token,
      :refresh_token => access_token.refresh_token,
      :token_expires_at => access_token.expires_at
    )

    @user.save
    redirect_to @user
  end
end
