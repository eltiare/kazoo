module Kazoo;   end

base_path = File.dirname(__FILE__)
Dir["#{base_path}/kazoo/*.rb"].each { |library| require library }