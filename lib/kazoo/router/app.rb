class Kazoo::Router
  
  class App
    
    include Common
    
    set :type, :app
      
    def self.map(opts = {}, &blk)
      @_context_options = opts
      @_context ||= Context.new(self, opts)
      @_context.instance_eval(&blk)
      self
    end#def map
    
    def self.context_options
      @_context_opts
    end
    
    def self.add_route(route, name=nil)
      routes << route
      named_routes[name.to_sym] = route if name
    end
    
    def self.routes
      @_routes ||= []
    end
    
    def self.named_routes
      @_named_routes ||= {}
    end
    
    def routes
      @_routes ||= self.class.routes.dup
    end
    
    def named_routes
      @_named_routes ||= self.class.named_routes.dup
    end
    
    
  end#module App

end#class Kazoo::Router
