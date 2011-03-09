require 'sinatra/base'

class Kazoo::Sinatra < Sinatra::Base
  
  include Kazoo::App
  
  enable  :sessions
  
  before do
    params.merge!(kenv['params']) if kenv['params']
  end
  
  def call(env)
    puts '============ Sinatra Environment: ==============='
    puts env.inspect
    
    dup.call!(env)  
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

  
end
