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
end
