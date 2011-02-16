Kazoo
=====

Kazoo is a Ruby library that aims to make your Rack applications behave like one. So far, it's very minimal with a simple router and some methods added to Sinatra to make it easier to have multiple Sinatra apps act more cohesively. Please note the current version on this: 0.0.3. This is nowhere near finished! It is on rubygems.org so that you can install it by running:

    gem install kazoo

The Kazoo router takes string paths and matches them to apps with no bells or whistles (yet). This is how you use it in a config.ru file:

    require 'rubygems'
    require 'kazoo'
    
    # Omitted code that pulls in Sinatra apps...
    
    run Kazoo::Router.map {
      match '/feeds', :to => Feeds
      match '/control/feeds', :to => Control::Feeds
      error_handler DogCatcher
    }
    
Use the match method to specify the route and the :to option to specify the application. You can specify an app to handle errors (like page not found or server errors), though this feature is not complete right now. I will get this up and going shortly, and when I do I will update this readme.

The `Kazoo::Sinatra` class overrides the render method to automatically add the name of the app to the view path. So an app named `Feeds` will have the default base path of "./views/feeds". `Admin::Feeds` will have a base path of './views/admin/feeds'. You can override this by putting a slash in your template path. See the Sinatra docs for more details.  The default layout is './views/layouts/application.#{template_engine}' though you can override this with the same rules as above.


In order to facilitate the fact that apps can be mounted at different paths, url helpers are included.

    require 'kazoo/sinatra'
    
    class Feeds < Kazoo::Sinatra
    
      set_paths(
        :index => '/',
        :show => '/:id'
      )
      
      get path(:index) do
        erubis :index
      end
      
      get path(:show) do
        @feed = Feed.find(params[:id])
        erubis :show
      end
    
      #alternatively, you can declare paths inline
      
      get path(:show, '/:id') do
        @feed = Feed.find(params[:id])
        erubis :show
      end
      
    end
    
    #.views/feeds/show.erubis
    <p>This is the generated URL for this page: <%= url(:show, :id => @feed.id) %></p>
    
    
If you run into any problems or have suggestions, feel free to send a ticket to /dev/null. Or you can submit one at https://github.com/eltiare/kazoo/issues, your choice.