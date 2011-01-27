class Kazoo::Router
  
  def self.map(&blk)
    instance = new
    instance.instance_eval(&blk)
    instance
  end
  
  def initialize
    @routes = []
  end
  
  def match(path, options = {})
    raise "You must match a route to an app using :to" unless options[:to] && options[:to].respond_to?(:call)
    if path.is_a?(Regexp)
      @routes << [ path, options[:to] ]
    elsif path.is_a?(String)
      @routes << [ Regexp.new("^#{path}"), options[:to] ]
    end
  end
  
  def error_handler(app)
    @error_handler = app
  end
  
  def call(env)
    @routes.each do |route|
      if matches = route[0].match(env['REQUEST_PATH'])
        env['HTTP_PREFIX'] = matches[0]
        env['PATH_INFO'] = env['PATH_INFO'].sub(route[0], '')
        response = route[1].call(env)
        return response if response[1]['X-Cascade'] != 'pass'
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
