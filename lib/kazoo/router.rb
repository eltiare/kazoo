class Kazoo::Router
  
  module App
    
    def self.included(klass)
      klass.send(:include, Dispatch)
      klass.set :type, :app
    end
    
  end
  
  
  module Dispatch
    
    def self.included(klass)
      klass.send(:extend, ClassMethods)
      klass.set :type, :dispatch
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
      
      def map(&blk)
        new.map(&blk)
      end
      
    end
    
    def set(var,val)
      @_settings ||= {}
      @_settings[var.to_sym] = val
    end
    
    def get(var)
      @_settings ||= {}
      @_settings[var.to_sym] || self.class.get(var)
    end
    
    def map(&blk)
      @context ||= Context.new(self)
      @context.instance_eval(&blk)
      self
    end
    
    def routes
      @routes ||= []
    end
    
    def named_routes
      @named_routes ||= {}
    end
    
    def error_handler(app)
      @error_handler = app
    end
    
    def general_handler(app)
      @general_handler = app
    end
    
    def kenv
      @env['kazoo'] ||= {}
    end
    
    def call(env)
      @env = env
      kenv['params'] ||= {}
      
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
          return response unless response[1]['X-Cascade'] == 'pass'
        elsif get(:mode) == :app && params
          return params
        end
        
      end
      
      # If no routes found
      default_response = [404, {'Content-Type' => 'text/plain', "X-Cascade" => "pass"}, 'The requested URI is not found']
      if @error_handler
        env['error'] = 'not_found'
        env['default_response'] = default_response
        @error_handler.call(env)
      else
        default_response
      end
    end

  end
  
  include Dispatch
  
end
