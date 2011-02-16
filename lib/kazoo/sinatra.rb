require 'sinatra/base'

class Kazoo::Sinatra < Sinatra::Base
  
  enable  :sessions
  
  before do
    params.merge!(kenv['params']) if kenv['params']
  end
  
  def ksession
    session['kazoo'] ||= {}
  end
  
  def kenv
    @request.env['kazoo'] ||= {}
  end
  
  def current_user=(user)
    if user
      ksession['user_id'] = user.id
      ksession['user_class'] = user.class.name
    else
      ksession['user_class'] = ksession['user_id'] = nil
    end
    user
  end
  
  def current_user
    @_kcu ||= Kernal.const_get(k).find(ksession['user_id']) if ksession['user_id']
  end
  
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
  
  def url(name = '', opts = {})
    if name.is_a?(Symbol)
      raise ArgumentError, "Invalid url name: #{name}" unless paths[name]
    
      url_path = paths[name].split('/').map { |part|
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

private

  def decamelize(class_name)
    parts = class_name.split('::')
    parts.map { |part|
      part.gsub(/([A-Z])/, '_\1').gsub(/(^\_)|(\_$)/, '').downcase
    }.join('/')
  end
  
end
