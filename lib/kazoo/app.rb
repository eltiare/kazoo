module Kazoo::App
  
  include Kazoo::Router::App
  
  def self.included(klass)
    klass.send(:extend, ClassMethods)
  end
  
  module ClassMethods
  
    def path_options(val)
      if val.is_a?(Hash)
        @_route_options = val
      elsif val
        raise ArgumentError, "route_options must be a hash"
      else
        @_route_options || {}
      end
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
        route = Route.new(path, opts)
        add_route(route, name.to_sym)
        path
      else
        raise ArgumentError, "#The route `{name}` does not exist" unless named_routes[name]
        named_routes[name].to_s if named_routes[name]
      end
    end
    
  end
  
  def path(name,path,opts)
    self.class.path(name,path,opts)
  end
  
  def url(name = '', opts = {})
    
    if name.is_a?(Symbol)
      raise ArgumentError, "Invalid url name: #{name}" unless named_routes[name]
    
      url_path = named_routes[name].to_s.split('/').map { |part|
        next unless part.is_a?(String)
        if matches = part.match(/^:([a-z_]+)$/i)
          matched = matches[1].downcase
          opts[matched] || opts[matched.to_sym] || params[matched] || raise("You need to pass '#{matched}' to generate URL")
        else
          part
        end
      }.join('/')
      
      # Check for prefix
      full_path = kenv['HTTP_PREFIX'] ? File.join(kenv['HTTP_PREFIX'], url_path) : url_path
      
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
