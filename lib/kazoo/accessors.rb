module Kazoo
  
  def self.admin_router(&blk)
    @_admin_router ||= Kazoo::Router.new
    @_admin_router.map(&blk) if block_given?
    @_admin_router
  end

end

module KMod; end
