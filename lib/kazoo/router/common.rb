class Kazoo::Router
  
  module Common
    
    def self.included(klass)
      klass.send(:extend, ClassMethods)
    end
    
    module ClassMethods
      
      def set(var, val)
        @_settings ||= {}
        @_settings[var.to_sym] = val
      end
      
      def get(var)
        @_settings ||= {}
        @_settings[var.to_sym]
      end
      
      def context_options
        nil
      end
      
    end#ClassMethods
    
    def set(var,val)
      @_settings ||= {}
      @_settings[var.to_sym] = val
    end
    
    def get(var)
      @_settings ||= {}
      @_settings[var.to_sym] || self.class.get(var)
    end
    
    def map(opts = {}, &blk)
      opts = self.class.context_options.merge(opts) if self.class.context_options
      @context ||= Context.new(self, opts)
      @context.instance_eval(&blk)
      self
    end
    
    def add_route(route, name=nil)
      routes << route
      named_routes[name.to_sym] = route if name
    end
    
    def routes
      @routes ||= []
    end
    
    def named_routes
      @named_routes ||= {}
    end
    
    def kenv
      @env['kazoo'] ||= {}
    end
    
    def call(env)
      @env = env
      kenv['params'] ||= {}
      
      #TODO: This hack is causing problems. Figure out regexp to match paths better. 
      env['PATH_INFO'] = "#{env["PATH_INFO"]}/" unless %r'/$'.match(env['PATH_INFO'])
      
      @routes.each do |route|
        
        params = route.extract_params(env['PATH_INFO'])
        
        if params && route.app
          kenv['params'].merge!(params)
          
          match = route.to_regexp.match(env['PATH_INFO'])[0]
          kenv['path_prefix'] = kenv['path_prefix'] ? File.join(kenv['path_prefix'], match) : match
          
          env['PATH_INFO'] = env['PATH_INFO'].sub(match, '')
          env['PATH_INFO'] = "/#{env['PATH_INFO']}" unless env['PATH_INFO'].match(%r'^/')
          
          response = route.app.call(env)
          
          if response[1]['X-Cascade'] == 'pass'
            next 
          elsif @error_handler && response[0] > 399
            return @error_handler.call(env, *response)
          else
            return response
          end
          
        elsif get(:mode) == :app && params
          return params
        end
        
      end
      
      # If no routes found
      default_response = [404, {'Content-Type' => 'text/plain', "X-Cascade" => "pass"}, 'The requested URI is not found']
      @error_handler ?  @error_handler.call(env, *default_response) :  default_response
    end
    
  end
  
end
