class SiteController < ApplicationController
  before_filter :setup_gplus

  def index
    @auth_url = @gplus.authorize_url
    @offline_auth_url = @gplus.authorize_url(:access_type => 'offline')
  end
end
