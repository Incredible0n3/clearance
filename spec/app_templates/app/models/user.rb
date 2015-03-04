class User
  include Mongoid::Document
  include Mongoid::Timestamps
  
  def previously_existed?
    true
  end
end
