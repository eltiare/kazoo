module Kazoo::App
  
  def self.included(klass)
    klass.send(:extend, ClassMethods)
  end
  
  module ClassMethods
    
    def krouter
      @_krouter ||= Kazoo::Router::App.new
    end
  
    def path_options=(val)
      if val.is_a?(Hash)
        @_route_options = val
      else
        raise ArgumentError, "route_options must be a hash"
      end
    end
    
    def path_options
      @_route_options || {}
    end
    
    def set_paths(opts)
      opts.each { |k,v| path(k,v) }
    end
  
    def path(name, path = nil, opts = {})
      opts = path_options.merge(opts)
      
      path_prefix = opts.delete(:path_prefix)
      name_prefix = opts.delete(:name_prefix)
      
      name = "#{name_prefix}_#{name}" if name_prefix
      
      if path
        raise ArgumentError, "Path must be a string" unless path.is_a?(String)
        path = File.join(path_prefix, path) if path_prefix
        route = Kazoo::Router::Route.new(path, opts.merge(:app_mode => true))
        krouter.add_route(route, name.to_sym)
        path
      else
        raise ArgumentError, "#The route `{name}` does not exist" unless krouter.named_routes[name]
        krouter.named_routes[name].to_s
      end
    end
    
  end
  
  def path(name,path,opts)
    self.class.path(name,path,opts)
  end
  
  def krouter
    self.class.krouter
  end
  
  def url(name = '', opts = {})
    
    if name.is_a?(Symbol)
      raise ArgumentError, "Invalid url name: #{name}" unless krouter.named_routes[name]
    
      url_path = krouter.named_routes[name].to_s.split('/').map { |part|
        next unless part.is_a?(String)
        if matches = part.match(/^:([a-z_]+)$/i)
          matched = matches[1].downcase
          opts[matched] || opts[matched.to_sym] || params[matched] || raise("You need to pass '#{matched}' to generate URL")
        else
          part
        end
      }.join('/')
      
      # Check for prefix
      full_path = kenv['path_prefix'] ? File.join(kenv['path_prefix'], url_path) : url_path
      
      format = opts[:format] || opts['format']
      full_path << ".#{format}" if format
      
      full_path
    else
      kenv['HTTP_PREFIX'] ? File.join(kenv['HTTP_PREFIX'], name) : name
    end
    
  end
  
  
  def decamelize(class_name)
    parts = class_name.split('::')
    parts.map { |part|
      part.gsub(/([A-Z])/, '_\1').gsub(/(^\_)|(\_$)/, '').downcase
    }.join('/')
  end

end
