class Kazoo::Bouncer
  
  def authenticators
    @_authenticators ||= []
  end
  
  def self.add_authenticator(klass)
    authenticators << klass
  end
  
  def initialize(env)
    @env = env
    @request = Rack::Request.new(env)
  end
  
  def request
    @request
  end
  
  def session
    @env['rack.session']
  end
  
  def params
    @request.params
  end
  
  def current_user
    @_current_user ||= if session['kazoo.user'][0]
      eval(session['kazoo.user'][0]).find(session['kazoo.user'][1]) rescue nil
    end
  end
  
  def forget
    session.delete('kazoo.user')
  end
  
  def authenticate!
    self.class.authenticators.each { |auth|
      if user = auth.new.call(@req)
        session['kazoo.user'] = [user.class.name, user.id]
        return user
      end
    } unless current_user
  end
  
  
  
  
  
end