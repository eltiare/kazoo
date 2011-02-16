class Kazoo::Router
  
  def self.map(&blk)
    new.map(&blk)
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
    @routes.each do |route|
      env['PATH_INFO'] = "#{env["PATH_INFO"]}/" unless %r'/$'.match(env['PATH_INFO'])
      params = route.extract_params(env['PATH_INFO'])
      
      if params && route.app
        kenv['params'] ||= {}
        kenv['params'].merge!(params)
        
        match = route.to_regexp.match(env['PATH_INFO'])[0]
        kenv['path_prefix'] = kenv['path_prefix'] ? File.join(kenv['path_prefix'], match) : match
        
        env['PATH_INFO'] = env['PATH_INFO'].sub(match, '')
        env['PATH_INFO'] = "/#{env['PATH_INFO']}" unless env['PATH_INFO'].match(%r'^/')
        
        response = route.app.call(env)
        return response unless response[1]['X-Cascade'] == 'pass'
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
