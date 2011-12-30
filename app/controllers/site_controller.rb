class SiteController < ApplicationController
  before_filter :setup_gplus

  def index
    # Generate an authorization URL
    @auth_url = @gplus.authorize_url

    # Generate an authorization URL that requests offline access.
    # Note that offline access is required to be able to refresh a user's OAuth token.
    # Otherwise, you can only access their data until their token expires (currently 1 hour).
    @offline_auth_url = @gplus.authorize_url(:access_type => 'offline')
  end
end
