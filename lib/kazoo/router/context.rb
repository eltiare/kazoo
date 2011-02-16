class Kazoo::Router
  
  class Context
    
    def initialize(router, opts = {})
      @router = router
      @opts = opts
    end
    
    def match(path, opts)
      opts = @opts.merge(opts)
      name = extract_name(opts)
      route = Route.new(path, opts)
      @router.named_routes[name] = route if name
      @router.routes << route
      route
    end
    
    def context(opts = {})
      opts = opts.dup
      
      if @opts[:path_prefix] && opts[:path_prefix]
        opts[:path_prefix] = File.join(@opts[:path_prefix], opts[:path_prefix])
      end
      
      if @opts[:name_prefix] && opts[:name_prefix]
        opts[:name_prefix] = @opts[:name_prefix] + '_' + opts[:name_prefix]
      end
      
      c = self.class.new(@router, opts)
      yield c
      c
      
    end
    
    def extract_name(opts)
      
    end
    
    def error_handler(app)
      @router.error_handler(app)
    end
    
  end
  
end
