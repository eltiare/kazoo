class Kazoo::Router
  
  module Dispatch
    
    def self.included(klass)
      klass.send(:include, Common)
      klass.set :type, :dispatch
      klass.send(:extend, ClassMethods)
    end
    
    module ClassMethods
      
      def map(&blk)
        new.map(&blk)
      end
      
    end
    
    def error_handler(app)
      @error_handler = app
    end
    
    def general_handler(app)
      @general_handler = app
    end
    
  end
  
  
end
