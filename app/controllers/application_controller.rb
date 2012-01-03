class ApplicationController < ActionController::Base
  protect_from_forgery

  # Setup a Gplus::Client for making public (non-authorized) requests, or for requesting authorization to access a user's data
  def setup_gplus
    @gplus = Gplus::Client.new(
      :api_key => GPLUS_CONFIG['api_key'],
      :client_id => GPLUS_CONFIG['client_id'],
      :client_secret => GPLUS_CONFIG['client_secret'],
      :redirect_uri => GPLUS_CONFIG['redirect_uri']
    )
  end

  # Setup a Gplus::Client authorized to use the specified user's stored OAuth token
  def setup_authorized_gplus(user)
    setup_gplus
    access_token = @gplus.authorize(user.token, user.refresh_token, user.token_expires_at)

    # Check if the access token was implicitly refreshed
    # If it was, store the user's new token and the time that it expires at
    if @gplus.access_token_refreshed?
      user.update_attributes(:token => access_token.token, :token_expires_at => access_token.expires_at)
    end
  end
end
