class UsersController < ApplicationController
  before_filter :get_user

  def show
  end

  def profile
    # Get the person that Gplus is authorized as
    @profile = @gplus.get_person('me')

    # Do a search for people with the same name, limited to 3 results
    @search_results = @gplus.search_people(@profile['displayName'], :maxResults => 3)

    # Get additional results for people with the same name, using the :pageToken option and the 'nextPageToken' from the previous search results
    @more_search_results = @gplus.search_people(@profile['displayName'], :maxResults => 3, :pageToken => @search_results['nextPageToken'])
  end

  def activities
    # List the activities for the person that Gplus is authorized as
    @activities = @gplus.list_activities('me')

    # List the comments for the person's last activity
    @comments = @gplus.list_comments(@activities['items'].last['id'])

    # Find a specific comment
    @last_comment = @gplus.get_comment(@comments['items'].last['id'])

    # List the people who +1'd the person's last activity
    @plusoners = @gplus.list_people_by_activity(@activities['items'].last['id'], 'plusoners')

    # List the people who reshared the person's last activity
    @resharers = @gplus.list_people_by_activity(@activities['items'].last['id'], 'resharers')
  end

private
  def get_user
    @user = User.find(params[:id])

    # Call setup_authorized_gplus method in ApplicationController, to initialize a Gplus::Client with the user's stored OAuth token
    setup_authorized_gplus(@user)
  end
end
