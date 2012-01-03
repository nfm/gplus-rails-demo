# Demo app for gplus gem

[gplus](https://github.com/nfm/gplus) is a complete implementation of the Google+ API for Ruby.

This repository is an example Rails 3.1 app for `gplus`. You can browse the source code, or clone the repository and run it locally.

# Running the app locally

1. Clone this repository:

        git clone git://github.com/nfm/gplus-rails-demo.git
        cd gplus-rails-demo

2. Add [your Google+ application's credentials](https://code.google.com/apis/console) to `config/gplus.yml.example`, and rename the file:

        # Add your API key, client ID, client secret, and redirect URI to config/gplus.yml.example
        mv config/gplus.yml.example config/gplus.yml

3. Migrate the database to create a users table:

        bundle exec rake db:migrate

4. Start WEBrick:

        rails server

5. Navigate to [http://localhost:3000](http://localhost:3000), and authorize your application for either online or offline access

6. Navigate to [http://localhost:3000/users/1](http://localhost:3000/users/1) and view the example data retrieved from your Google+ profile

# Recreating the example application's functionality

If you have an existing application that you want to add `gplus` to, you can model it after this example application by completing the following steps.

You should read the [gplus README](https://github.com/nfm/gplus) for more information. You might also find the [full documentation](http://rubydoc.info/github/nfm/gplus/master/frames) useful.

1. Add `gplus` to your Gemfile and run `bundle install`

        gem 'gplus', '~> 2.0.0'

2. Create a migration to add the following columns to your user model and run `rake db:migrate`:

        def change
          add_column :users, :token, :string
          add_column :users, :token_expires_at, :string
          add_column :users, :refresh_token, :string
        end

3. Define methods to initialize a Google+ API client in your ApplicationController:

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

4. Set up a controller to handle OAuth callbacks:

        rails generate controller oauth2 callback

        # Add a route for it to config/routes.rb
        match 'oauth2/callback' => 'oauth2#callback'

5. Implement your callback action. (Use whatever method you like to get the currently logged in user, or create a new one):

        class OAuth2Controller < ApplicationController
          def callback
            setup_gplus
            access_token = @gplus_client.authorize(params[:code])

            # You need to find or create a user here so that you can store the access_token's attributes

            @user.update_attributes(
              :token => access_token.token,
              :refresh_token => access_token.refresh_token,
              :token_expires_at => access_token.expires_at
            )
          end
        end

6. Generate an authorization URL and link to it in a view. When a user clicks the link, they will be redirected to Google to authorize your app. After authorization, they will be redirected back to /oauth2/callback, where we're storing their OAuth token for persistent access to their data.

        # app/controllers/whatever_controller.rb
        def some_action
          setup_gplus
        end

        # app/views/whatever_controller/some_action.html.erb
        <%= link_to 'Authorize this app for Google+', @gplus.authorize_url %>

        # You'll probably want to generate an authorize_url which requests offline_access
        # so that you can access the user's Google+ profile for more than 1 hour
        <%= link_to 'Authorize this app for Google+', @gplus.authorize_url(:access_type => :offline) %>


7. You can now create an authorized Google+ client and make API calls:

        # app/controllers/some_other_controller.rb
        def show
          setup_authorized_gplus(current_user)
          @gplus.get_person('me')
        end
