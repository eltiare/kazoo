require 'sinatra/base'

class Kazoo::Sinatra < Sinatra::Base
  
  def render(engine, data, options = {}, *args)
    
    if !options[:views] && data.is_a?(Symbol) && !data.to_s.match('/')
      data = :"#{decamelize(self.class.name)}/#{data}"
      options[:layout] = :'layouts/application' if options[:layout].nil?
    end
    
    if options[:layout] && !options[:layout].to_s.match('/')
      options[:layout] = :"layouts/#{options[:layout]}"
    end
    
    super(engine, data, options, *args)
    
  end
  
  
  def self.set_paths(opts)
    opts.each { |k,v| path(k,v) }
  end
  
  
  def self.path(name, path = nil)
    if path
      raise ArgumentError, "Path must be a string" unless path.is_a?(String)
      paths[name.to_sym] = path
      path
    else
      paths[name.to_sym]
    end
  end
  
  def self.paths
    @paths ||= {}
  end
  
  def path(name,path)
    self.class.path(name,path)
  end
  
  def paths
    self.class.paths
  end
  
  def url(name, opts = {})
    n = name.to_sym
    raise ArgumentError, "Invalid url name: #{name}" unless paths[n]
    
    url_path = paths[n].split('/').map { |part|
      next unless part.is_a?(String)
      if matches = part.match(/^:([a-z_]+)$/i)
        matched = matches[1].downcase
        opts[matched] || opts[matched.to_sym] || params[matched] || raise("You need to pass '#{matched}' to generate URL")
      else
        part
      end
    }.join('/')
    
    # Check for prefix
    full_path = request.env['HTTP_PREFIX'] ? File.join(request.env['HTTP_PREFIX'], url_path) : url_path
    
    format = opts[:format] || opts['format']
    full_path << ".#{format}" if format
    
    full_path
  end

private

  def decamelize(class_name)
    parts = class_name.split('::')
    parts.map { |part|
      part.gsub(/([A-Z])/, '_\1').gsub(/(^\_)|(\_$)/, '').downcase
    }.join('/')
  end
  
end
