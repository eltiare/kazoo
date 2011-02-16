module Kazoo::Support
  
  
  def load_files(files)
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

  
end#module
