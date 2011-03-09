class Kazoo::Router
  
  class Context
    
    def initialize(router, opts = {})
      @router = router
      @opts = opts
    end
    
    def match(path, opts)
      opts = @opts.merge(opts)
      name = extract_name(opts)
      
      if get(:mode) == :app 
        opts[:app_mode] =  true
      else
        opts[:default_app] = @default_app
      end
      
      route = Route.new(path, opts)
      @router.named_routes[name] = route if name
      @router.routes << route
      route
    end
    
    def set(var,val)
      @router.set(var,val)
    end
    
    def get(var)
      @router.get(var)
    end
    
    def default_app(app)
      raise ArgumentError, "default_app must be a rack application (#{app} doesn't respond to call)" unless app.respond_to?(:call)
      raise NameError, "NameError: undefined local variable or method `default_app' for #{self}" if get(:mode) == :app
      @default_app = app
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
      if @opts[:name_prefix]  && opts[:name]
        "#{@opts[:name_prefix]}_#{opts[:name]}"
      elsif opts[:name]
        opts[:name]
      else
        nil
      end
    end
    
    def error_handler(app)
      @router.error_handler(app)
    end
    
  end
  
end
