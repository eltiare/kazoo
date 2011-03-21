module Kazoo::PathBranch
  
  def self.included(klass)
    
    mod = nil
    
    constants.each { |const|
      m = Kernal.const_get("#{name}::#{const}")
      begin
        if klass.ancestors.include?(Kernal.const_get(m.orm_class))
          mod = m
          break
        end
      rescue NameError
        #Keep searching if the constant does not exist
      end
    }    
    
    mod ? klass.send(:include, mod) :  raise("Framework for #{klass.name} not found.")
    
  end
  
end
