class Kazoo::Bouncer
  
  class Authenticator
    
    def self.inherited(klass)
      Kazoo::Bouncer.add_authenticator klass
    end
    
    def call(req)
      @_params = req.params
      @_request = req
      run
    end
    
    def params
      @_params
    end
    
    def request
      @_request
    end
    
    def run
      raise NotImplementedError, "You must override the `run` method in #{self.class.name}. Please don't punch any ducks"
    end
    
  end
  
  
end
