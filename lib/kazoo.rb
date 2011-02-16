$LOAD_PATH.push(File.dirname(__FILE__))

require 'cgi'

module Kazoo;   end

require "kazoo/support"
require "kazoo/accessors"

require 'kazoo/router/route'
require 'kazoo/router/context'
require "kazoo/router"