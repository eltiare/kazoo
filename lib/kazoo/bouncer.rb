class Kazoo::Bouncer
  
  def self.authenticators
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
    @request.session
  end
  
  def current_user
    @_current_user ||= if session['kazoo.user'] && session['kazoo.user'][0]
      Kernel.const_get(session['kazoo.user'][0]).find(session['kazoo.user'][1]) rescue nil
    end
  end
  
  def current_user=(user)
    if user.nil?
      forget
    else
      session['kazoo.user'] = [user.class.name, user.id]
      user
    end
  end
  
  def authenticated?
    session['kazoo.authenticated'] ? true : false
  end
  
  def forget
    session.delete('kazoo.authenticated')
    session.delete('kazoo.user')
  end
  
  def authenticate!
    self.class.authenticators.each { |auth|
      user = auth.new.call(request)
      if user
        session['kazoo.authenticated'] = '1'
        self.current_user = user if user.class.respond_to?(:find)
        puts 'Session: ', session.inspect
        return user
      end
    }
    nil
  end
  
end