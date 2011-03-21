require 'sinatra/base'

class Kazoo::Sinatra < Sinatra::Base
  
  include Kazoo::App
  
  before do
    params.merge!(kenv['params']) if kenv['params']
  end
  
  def call!(env)
    @_bouncer ||= Kazoo::Bouncer.new(env)
    super
  end
  
  def ksession
    session['kazoo'] ||= {}
  end
  
  def kenv
    @request.env['kazoo'] ||= {}
  end
  
  def current_user=(user)
    @_bouncer.current_user = user
    user
  end
  
  def current_user
    @_bouncer.current_user
  end
  
  def authenticate!
    unless @_bouncer.authenticated?
      if @_bouncer.authenticate!
        halt 302, {'Location' => '//' + request.env['HTTP_HOST']  + request.env['REQUEST_PATH']}, ''
      else
        throw(:halt, [401, "Not authorized\n"])
      end
    end
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
