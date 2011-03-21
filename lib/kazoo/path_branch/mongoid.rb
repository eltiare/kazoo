module Kazoo::PathBranch::Mongoid
  
  def self.included(klass)
    klass.instance_eval do
      
      field  :pb_parent_id,   :type => BSON::ObjectId
      field  :pb_order,       :type => Integer
      field  :pb_title,       :type => String
      field  :pb_slug,        :type => String
      
      field  :pb_app_class,   :type => String
      field  :pb_app_id,      :type => String
      
      index  :pb_parent_id,   :background => true
      index  :pb_order,       :background => true
    end
  end
  
  def self.orm_class
    'Mongoid::Document'
  end
  
  def parent
    find(pb_parent_id) if pb_parent_id
  end
  
  def children
    self.class.where('pb_parent_id' => id).order_by(:pb_order.asc)
  end
  
  def app=(app)
    self.pb_app_class = app.class.name
    self.pb_app_id    = app.id
  end
  
  def run
    Kernel.const_get(pb_app_class).run(pb_app_id)
  end
  
  
end
