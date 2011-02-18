class Kazoo::Router
  
  class Route
    
    def initialize(path, opts = {})
      
      @named_params = []
      @opts = opts
      
      # Extract & delete the special options
      app_mode = opts.delete(:app_mode)
      
      to = opts.delete(:to)
      default_app = opts.delete(:default_app)
      @app =  to || default_app
      
      raise ArgumentError, 'You must supply an application/block' if !@app && !app_mode
      
      @path_prefix = opts.delete(:path_prefix)
      @regex_prefix = opts.delete(:regex_prefix)
      opts.delete(:name_prefix)
      
      opts.each { |k,v|
        opts.delete(k)
        opts[k.to_s] = v
      }
      
      # Parse the path
      if path.is_a?(String)
        
        path = File.join(@path_prefix, path) if @path_prefix
        
        @passed_string = path
        
        @parts = path.split('/')
        @parts.shift if @parts[0].nil?
        
        regexp_parts = @parts.map { |part|
          # extracts the names of the path
          if matches = part.match(/^:([a-z]+[a-z0-9_]*)$/i)
            @named_params << matches[1].downcase
            "([^\/]+)"
          elsif part
            part
          else
            raise ArgumentError, 'Paths may not have blank parts'
          end
        }
        final_path = regexp_parts.join('/')
      elsif path.is_a?(Regexp)
        final_path = path.inspect
        final_path.gsub!(/(^\^)|(\$$)/, '') # Remove anchors
        final_path = File.join(@regex_prefix, file_path) if @regex_prefix
      else
        raise ArgumentError, "Invalid type passed to a route: #{path.class.name}. Must be either a string or regexp."
      end
      
      final_path = "/#{final_path}" unless final_path.match(%r"^\/")
      final_path = "#{final_path}/" unless final_path.match(%r"\/$")
      @matcher = Regexp.new(app_mode ? "^#{final_path}$" : "^#{final_path}" )
    end
    
    def to_s
      @passed_string || @matcher.inspect
    end
    
    def to_regexp
      @matcher
    end
    
    def app
      @app
    end
    
    def named_params
      @named_params
    end
    
    def extract_params(path)
      if matches = @matcher.match(path)
        obj = @opts.dup
        named_params.each_with_index { |np, i| obj[np] = matches[i + 1] }
        obj
      end
    end
    
    def path(opts = {})
      
      opts = @opts.merge(opts)
      
      raise "Path cannot be generated from a Regexp" unless @passed_string
      
      unused_params = @named_params - opts.keys.map { |key| key.to_s }
      raise ArgumentError, "You must supply the following params: #{unused_params.inspect}" if unused_params.size > 0
      
      str = @passed_string.dup
      
      extra_keys = []
      
      opts.keys.each { |key|
        if test = str.sub!(%r"(\:|\*)#{key}", opts[key].to_s)
          raise ArgumentError, "#{key} requires a value" if opts[key].nil?
        else
          extra_keys << key
        end
      }
      
      if extra_keys.size > 0
        pstring = extra_keys.map { |key|
          "#{CGI.escape(key.to_s)}=#{CGI.escape(opts[key].to_s)}" unless opts[key].nil?
        }.compact.join('&')
        "#{str}?#{pstring}"
      else
        str
      end#if 
      
    end#def
    
  end#class
  
end
