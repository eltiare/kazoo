module Kazoo::Support
  
  HTTP_CODES = {
    400 => :bad_request,
    401 => :unauthorized,
    402 => :payment_required,
    403 => :forbidden,
    404 => :not_found,
    405 => :method_not_allowed,
    406 => :not_acceptable,
    500 => :internal_server_error,
    501 => :not_implemented,
    502 => :bad_gateway,
    503 => :service_unavailable,
    504 => :gateway_timeout,
    505 => :http_version_not_supported
  }
  
  
  def decamelize(class_name)
    parts = class_name.split('::')
    parts.map { |part|
      part.gsub(/([A-Z])/, '_\1').gsub(/(^\_)|(\_$)/, '').downcase
    }.join('/')
  end
  
  def self.load_files(files)
    excepted_inits = []
    files.sort.each do |init|
      begin
        require init
      rescue => e
        excepted_inits.push([init, {e => 0}])
      end
    end
    
    # Go through the ones that might have dependencies on other inits.
    max_error_size = excepted_inits.size * 4
    
    while excepted_inits.size > 0
      
      begin
        excepted_init = excepted_inits.pop
        require excepted_init[0]
      rescue => e
        c = e.class
        excepted_init[1][c] ||= 0
        
        if excepted_init[1][c]  > max_error_size
          raise
        else
          excepted_init[1][c] += 1
          excepted_inits.unshift(excepted_init)
        end#if
        
      end#begin
      
    end#while
  
  end#def
  
  def load_files(files)
    self.class.load_files(files)
  end

  
end#module
