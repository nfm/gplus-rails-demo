class ApplicationController < ActionController::Base
  protect_from_forgery

  def setup_gplus
    @gplus = Gplus::Client.new(
      :api_key => GPLUS_CONFIG['api_key'],
      :client_id => GPLUS_CONFIG['client_id'],
      :client_secret => GPLUS_CONFIG['client_secret'],
      :redirect_uri => GPLUS_CONFIG['redirect_uri']
    )
  end

  def setup_authorized_gplus(user)
    @gplus = Gplus::Client.new(
      :token => user.token,
      :refresh_token => user.refresh_token,
      :token_expires_at => user.token_expires_at,
      :api_key => GPLUS_CONFIG['api_key'],
      :client_id => GPLUS_CONFIG['client_id'],
      :client_secret => GPLUS_CONFIG['client_secret'],
      :redirect_uri => GPLUS_CONFIG['redirect_uri']
    )
  end
end
